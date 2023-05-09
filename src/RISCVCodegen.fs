// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Alceste Scalas <alcsc@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

/// Functions to generate RISC-V assembly code from a typed Hygge AST.
module RISCVCodegen

open AST
open RISCV
open Type
open Typechecker

/// Exit code used in the generated assembly to signal an assertion violation.
let assertExitCode = 42 // Must be non-zero


/// Storage information for variables.
[<RequireQualifiedAccess; StructuralComparison; StructuralEquality>]
type internal Storage =
    /// The variable is stored in an integerregister.
    | Reg of reg: Reg
    /// The variable is stored in a floating-point register.
    | FPReg of fpreg: FPReg
    /// The variable is stored in memory, in a location marked with a
    /// label in the compiled assembly code.
    | Label of label: string
    /// This variable is stored on the stack, at the given offset (in bytes)
    /// from the memory address contained in the frame pointer (fp) register.
    | Frame of offset: int


/// Code generation environment.
type internal CodegenEnv = {
    /// Target register number for the result of non-floating-point expressions.
    Target: uint
    /// Target register number for the result of floating-point expressions.
    FPTarget: uint
    /// Storage information about known variables.
    VarStorage: Map<string, Storage>

    AtTopLevel: bool
}


/// Code generation function: compile the expression in the given AST node so
/// that it writes its results on the 'Target' and 'FPTarget' generic register
/// numbers (specified in the given codegen 'env'ironment).  IMPORTANT: the
/// generated code must never modify the contents of register numbers lower than
/// the given targets.
let rec internal doCodegen (env: CodegenEnv) (node: TypedAST): Asm =
    match node.Expr with
    | UnitVal -> Asm() // Nothing to do

    | BoolVal(v) ->
        /// Boolean constant turned into integer 1 if true, or 0 if false
        let value = if v then 1 else 0
        Asm(RV.LI(Reg.r(env.Target), value), $"Bool value '%O{v}'")

    | IntVal(v) ->
        Asm(RV.LI(Reg.r(env.Target), v))

    | FloatVal(v) ->
        // We convert the float value into its bytes, and load it as immediate
        let bytes = System.BitConverter.GetBytes(v)
        if (not System.BitConverter.IsLittleEndian)
            then System.Array.Reverse(bytes) // RISC-V is little-endian
        let word: int32 = System.BitConverter.ToInt32(bytes)
        Asm([ (RV.LI(Reg.r(env.Target), word), $"Float value %f{v}")
              (RV.FMV_W_X(FPReg.r(env.FPTarget), Reg.r(env.Target)), "") ])

    | StringVal(v) ->
        // Label marking the string constant in the data segment
        let label = Util.genSymbol "string_val"
        Asm().AddData(label, Alloc.String(v))
             .AddText(RV.LA(Reg.r(env.Target), label))

    | Var(name) ->
        // To compile a variable, we inspect its type and where it is stored
        match node.Type with
        | t when (isSubtypeOf node.Env t TUnit)
            -> Asm() // A unit-typed variable is just ignored
        | t when (isSubtypeOf node.Env t TFloat) ->
            match (env.VarStorage.TryFind name) with
            | Some(Storage.FPReg(fpreg)) ->
                Asm(RV.FMV_S(FPReg.r(env.FPTarget), fpreg),
                    $"Load variable '%s{name}'")
            | Some(Storage.Label(lab)) ->
                Asm([ (RV.LA(Reg.r(env.Target), lab), $"Load variable '%s{name}'")
                      (RV.FMV_W_X(FPReg.r(env.FPTarget), Reg.r(env.Target)),
                       $"Transfer '%s{name}' to fp register") ])
            | Some(Storage.Frame(offset)) ->
                failwith $"BUG: float variable with storage on stack not supported yet."
            | Some(Storage.Reg(_)) as st ->
                failwith $"BUG: variable %s{name} has unexpected storage %O{st}"
            | None -> failwith $"BUG: float variable without storage: %s{name}"
        | _ ->  // Default case for variables holding integer-like values
            match (env.VarStorage.TryFind name) with
            | Some(Storage.Reg(reg)) ->
                Asm(RV.MV(Reg.r(env.Target), reg), $"Load variable '%s{name}'")
            | Some(Storage.Label(lab)) ->
                Asm(RV.LA(Reg.r(env.Target), lab), $"Load variable '%s{name}'")
            | Some(Storage.Frame(offset)) ->
                Asm(RV.LW(Reg.r(env.Target), Imm12(offset), Reg.fp), $"Load variable '%s{name}'")
            | Some(Storage.FPReg(_)) as st ->
                failwith $"BUG: variable %s{name} has unexpected storage %O{st}"
            | None -> failwith $"BUG: variable without storage: %s{name}"

    | Add(lhs, rhs)
    | Sub(lhs, rhs)
    | Rem(lhs, rhs)
    | Div(lhs, rhs)
    | Mult(lhs, rhs) as expr ->
        // Code generation for addition and multiplication is very
        // similar: we compile the lhs and rhs giving them different target
        // registers, and then apply the relevant assembly operation(s) on their
        // results.

        /// Generated code for the lhs expression
        let lAsm = doCodegen env lhs
        // The generated code depends on the type of addition being computed
        match node.Type with
        | t when (isSubtypeOf node.Env t TInt) ->
            /// Target register for the rhs expression
            let rtarget = env.Target + 1u
            /// Generated code for the rhs expression
            let rAsm = doCodegen {env with Target = rtarget} rhs
            /// Generated code for the numerical operation
            let opAsm =
                match expr with
                    | Add(_,_) ->
                        Asm(RV.ADD(Reg.r(env.Target),
                                   Reg.r(env.Target), Reg.r(rtarget)))
                    | Sub(_,_) ->                      
                     Asm(RV.SUB(Reg.r(env.Target),
                                Reg.r(env.Target), Reg.r(rtarget)))
                    | Mult(_,_) ->
                        Asm(RV.MUL(Reg.r(env.Target),
                                   Reg.r(env.Target), Reg.r(rtarget)))
                    | Rem(_,_) ->
                        Asm(RV.REM(Reg.r(env.Target),
                                   Reg.r(env.Target), Reg.r(rtarget)))
                    | Div(_,_) ->
                        Asm(RV.DIV(Reg.r(env.Target),
                                   Reg.r(env.Target), Reg.r(rtarget)))
                    | x -> failwith $"BUG: unexpected operation %O{x}"
            // Put everything together
            lAsm ++ rAsm ++ opAsm
        | t when (isSubtypeOf node.Env t TFloat) ->
            /// Target register for the rhs expression
            let rfptarget = env.FPTarget + 1u
            /// Generated code for the rhs expression
            let rAsm = doCodegen {env with FPTarget = rfptarget} rhs
            /// Generated code for the numerical operation
            let opAsm =
                match expr with
                | Add(_,_) ->
                    Asm(RV.FADD_S(FPReg.r(env.FPTarget),
                                  FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | Sub(_,_) ->                         
                Asm(RV.FSUB_S(FPReg.r(env.FPTarget),
                              FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | Mult(_,_) ->
                    Asm(RV.FMUL_S(FPReg.r(env.FPTarget),
                                  FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | Div(_,_) ->
                    Asm(RV.FDIV_S(FPReg.r(env.FPTarget),
                                  FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | x -> failwith $"BUG: unexpected operation %O{x}"
            // Put everything together
            lAsm ++ rAsm ++ opAsm
        | t ->
            failwith $"BUG: numerical operation codegen invoked on invalid type %O{t}"

    | And(lhs, rhs)
    | Or(lhs, rhs)
    | Xor(lhs, rhs) as expr ->
        // Code generation for logical 'and' and 'or' is very similar: we
        // compile the lhs and rhs giving them different target registers, and
        // then apply the relevant assembly operation(s) on their results.
        
        /// Generated code for the lhs expression
        let lAsm = doCodegen env lhs
        /// Target register for the rhs expression
        let rtarget = env.Target + 1u
        /// Generated code for the rhs expression
        let rAsm = doCodegen {env with Target = rtarget} rhs
        /// Generated code for the logical operation
        let opAsm =
            match expr with
            | And(_,_) ->
                Asm(RV.AND(Reg.r(env.Target), Reg.r(env.Target), Reg.r(rtarget)))
            | Or(_,_) ->
                Asm(RV.OR(Reg.r(env.Target), Reg.r(env.Target), Reg.r(rtarget)))
            | Xor(_,_) ->
                Asm(RV.XOR(Reg.r(env.Target), Reg.r(env.Target), Reg.r(rtarget)))
            | x -> failwith $"BUG: unexpected operation %O{x}"
        // Put everything together
        lAsm ++ rAsm ++ opAsm

    | ShortAnd(lhs, rhs)
    | ShortOr(lhs, rhs) as expr ->
        /// Human-readable prefix for jump labels, describing the kind of
        /// relational operation we are compiling
        let labelName = match expr with
                        | ShortAnd(_,_) -> "ShortAnd"
                        | ShortOr(_,_) -> "ShortOr"
                        | x -> failwith $"BUG: unexpected operation %O{x}"

        /// Label to mark the end of the ShortCircuit And/Or code
        let labelEnd = Util.genSymbol $"%O{labelName}_end"

        // Compile the lhs expression, then jump to 'labelEnd' if the result is
        // false (in case of ShortAnd) or true (in case of ShortOr).
        // Otherwise, execute the rhs expression.
        (doCodegen env lhs)
            .AddText(
                match expr with
                | ShortAnd(_,_) -> 
                    RV.BEQZ(Reg.r(env.Target), labelEnd)
                | ShortOr(_,_) ->
                    RV.BNEZ(Reg.r(env.Target), labelEnd)
                | x -> failwith $"BUG: unexpected operation %O{x}"
            )
            ++ (doCodegen env rhs)
                .AddText(RV.LABEL(labelEnd), "")

    | Not(arg) 
    | CSIncr(arg)
    | CSDcr(arg) ->
        /// Generated code for the argument expression (note that we don't need
        /// to increase its target register)
        let asm = doCodegen env arg
        asm.AddText(RV.SEQZ(Reg.r(env.Target), Reg.r(env.Target)))
    

    | Eq(lhs, rhs)
    | Less(lhs, rhs) as expr ->
        // Code generation for equality and less-than relations is very similar:
        // we compile the lhs and rhs giving them different target registers,
        // and then apply the relevant assembly operation(s) on their results.

        /// Generated code for the lhs expression
        let lAsm = doCodegen env lhs
        // The generated code depends on the lhs and rhs types
        match lhs.Type with
        | t when (isSubtypeOf lhs.Env t TInt) ->
            // Our goal is to write 1 (true) or 0 (false) in the register
            // env.Target, depending on the result of the comparison between
            // the lhs and rhs.  To achieve this, we perform a conditional
            // branch depending on whether the lhs and rhs are equal (or the lhs
            // is less than the rhs):
            // - if the comparison is true, we jump to a label where we write
            //   1 in the target register, and continue
            // - if the comparison is false, we write 0 in the target register
            //   and we jump to a label marking the end of the generated code

            /// Target register for the rhs expression
            let rtarget = env.Target + 1u
            /// Generated code for the rhs expression
            let rAsm = doCodegen {env with Target = rtarget} rhs
            
            /// Human-readable prefix for jump labels, describing the kind of
            /// relational operation we are compiling
            let labelName = match expr with
                            | Eq(_,_) -> "eq"
                            | Less(_,_) -> "less"
                            | x -> failwith $"BUG: unexpected operation %O{x}"
            /// Label to jump to when the comparison is true
            let trueLabel = Util.genSymbol $"%O{labelName}_true"
            /// Label to mark the end of the comparison code
            let endLabel = Util.genSymbol $"%O{labelName}_end"

            /// Codegen for the relational operation between lhs and rhs
            let opAsm =
                match expr with
                | Eq(_,_) ->
                    Asm(RV.BEQ(Reg.r(env.Target), Reg.r(rtarget), trueLabel))
                | Less(_,_) ->
                    Asm(RV.BLT(Reg.r(env.Target), Reg.r(rtarget), trueLabel))
                | x -> failwith $"BUG: unexpected operation %O{x}"

            // Put everything together
            (lAsm ++ rAsm ++ opAsm)
                .AddText([
                    (RV.LI(Reg.r(env.Target), 0), "Comparison result is false")
                    (RV.J(endLabel), "")
                    (RV.LABEL(trueLabel), "")
                    (RV.LI(Reg.r(env.Target), 1), "Comparison result is true")
                    (RV.LABEL(endLabel), "")
                ])
        | t when (isSubtypeOf lhs.Env t TFloat) ->
            /// Target register for the rhs expression
            let rfptarget = env.FPTarget + 1u
            /// Generated code for the rhs expression
            let rAsm = doCodegen {env with FPTarget = rfptarget} rhs
            /// Generated code for the relational operation
            let opAsm =
                match expr with
                | Eq(_,_) ->
                    Asm(RV.FEQ_S(Reg.r(env.Target), FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | Less(_,_) ->
                    Asm(RV.FLT_S(Reg.r(env.Target), FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | x -> failwith $"BUG: unexpected operation %O{x}"
            // Put everything together
            (lAsm ++ rAsm ++ opAsm)
        | t ->
            failwith $"BUG: relational operation codegen invoked on invalid type %O{t}"

    | Min(lhs, rhs)
    | Max(lhs, rhs) as expr ->
        /// Generated code for the lhs expression
        let lAsm = doCodegen env lhs
        // The generated code depends on the lhs and rhs types
        
        match lhs.Type with
        | t when (isSubtypeOf lhs.Env t TInt) ->
            /// Target register for the rhs expression
            let rtarget = env.Target + 1u
            /// Generated code for the rhs expression
            let rAsm = doCodegen {env with Target = rtarget} rhs
            
            /// Human-readable prefix for jump labels, describing the kind of
            /// relational operation we are compiling
            let labelName = match expr with
                            | Max(_,_) -> "max"
                            | Min(_,_) -> "min"
                            | x -> failwith $"BUG: unexpected operation %O{x}"
            
            /// Label to jump to when the comparison is true
            let trueLabel = Util.genSymbol $"%O{labelName}_true"
            /// Label to mark the end of the comparison code
            let endLabel = Util.genSymbol $"%O{labelName}_end"

            /// Codegen for the relational operation between lhs and rhs
            let opAsm =
                match expr with
                | Max(_,_) ->
                    Asm(RV.BGE(Reg.r(env.Target), Reg.r(rtarget), trueLabel))
                | Min(_,_) ->
                    Asm(RV.BLT(Reg.r(env.Target), Reg.r(rtarget), trueLabel))
                | x -> failwith $"BUG: unexpected operation %O{x}"

            // Put everything together
            (lAsm ++ rAsm ++ opAsm)
                .AddText([
                    (RV.MV(Reg.r(env.Target), Reg.r(rtarget)), "right is greatest")
                    (RV.J(endLabel), "end max/min func")
                    (RV.LABEL(trueLabel), "")
                    (RV.MV(Reg.r(env.Target), Reg.r(env.Target)), "left is greatest")
                    (RV.LABEL(endLabel), "end of max/min func")
                ])

        | t when (isSubtypeOf node.Env t TFloat) ->
            /// Target register for the rhs expression
            let rfptarget = env.FPTarget + 1u
            /// Generated code for the rhs expression
            let rAsm = doCodegen {env with FPTarget = rfptarget} rhs
            /// Generated code for the numerical operation
            let opAsm =
                match expr with
                | Min(_,_) -> 
                    Asm(RV.FMIN_S(FPReg.r(env.FPTarget), 
                                  FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | Max(_,_) -> 
                    Asm(RV.FMAX_S(FPReg.r(env.FPTarget), 
                                  FPReg.r(env.FPTarget), FPReg.r(rfptarget)))
                | x -> failwith $"BUG: unexpected operation %O{x}"
            // Put everything together
            lAsm ++ rAsm ++ opAsm
        | t ->
            failwith $"BUG: numerical operation codegen invoked on invalid type %O{t}"

    | ReadInt ->
        (beforeSysCall [Reg.a0] [])
            .AddText([
                (RV.LI(Reg.a7, 5), "RARS syscall: ReadInt")
                (RV.ECALL, "")
                (RV.MV(Reg.r(env.Target), Reg.a0), "Move syscall result to target")
            ])
            ++ (afterSysCall [Reg.a0] [])

    | ReadFloat ->
        (beforeSysCall [] [FPReg.fa0])
            .AddText([
                (RV.LI(Reg.a7, 6), "RARS syscall: ReadFloat")
                (RV.ECALL, "")
                (RV.FMV_S(FPReg.r(env.FPTarget), FPReg.fa0), "Move syscall result to target")
            ])
            ++ (afterSysCall [] [FPReg.fa0])
    
    | Sqrt(arg) -> 
        let argCode = doCodegen env arg
        match arg.Type with
        | t when (isSubtypeOf arg.Env t TFloat) -> argCode.AddText(RV.FSQRT_S(FPReg.r(env.FPTarget), FPReg.r(env.FPTarget)))
        | t -> failwith $"BUG: Sqrt codegen invoked on unsupported type %O{t}"

    | Print(arg) ->
        /// Compiled code for the 'print' argument, leaving its result on the
        /// generic register 'target' or 'fptarget' (depending on its type)
        let argCode = doCodegen env arg
        // The generated code depends on the 'print' argument type
        match arg.Type with
        | t when (isSubtypeOf arg.Env t TBool) ->
            let strTrue = Util.genSymbol "true"
            let strFalse = Util.genSymbol "false"
            let printFalse = Util.genSymbol "print_true"
            let printExec = Util.genSymbol "print_execute"
            argCode.AddData(strTrue, Alloc.String("true"))
                .AddData(strFalse, Alloc.String("false"))
                ++ (beforeSysCall [Reg.a0] [])
                  .AddText([
                    (RV.BEQZ(Reg.r(env.Target), printFalse), "")
                    (RV.LA(Reg.a0, strTrue), "String to print via syscall")
                    (RV.J(printExec), "")
                    (RV.LABEL(printFalse), "")
                    (RV.LA(Reg.a0, strFalse), "String to print via syscall")
                    (RV.LABEL(printExec), "")
                    (RV.LI(Reg.a7, 4), "RARS syscall: PrintString")
                    (RV.ECALL, "")
                  ])
                  ++ (afterSysCall [Reg.a0] [])
        | t when (isSubtypeOf arg.Env t TInt) ->
            argCode
            ++ (beforeSysCall [Reg.a0] [])
                .AddText([
                    (RV.MV(Reg.a0, Reg.r(env.Target)), "Copy to a0 for printing")
                    (RV.LI(Reg.a7, 1), "RARS syscall: PrintInt")
                    (RV.ECALL, "")
                ])
                ++ (afterSysCall [Reg.a0] [])
        | t when (isSubtypeOf arg.Env t TFloat) ->
            argCode
            ++ (beforeSysCall [] [FPReg.fa0])
                .AddText([
                    (RV.FMV_S(FPReg.fa0, FPReg.r(env.FPTarget)), "Copy to fa0 for printing")
                    (RV.LI(Reg.a7, 2), "RARS syscall: PrintFloat")
                    (RV.ECALL, "")
                ])
                ++ (afterSysCall [] [FPReg.fa0])
        | t when (isSubtypeOf arg.Env t TString) ->
            argCode
            ++ (beforeSysCall [Reg.a0] [])
                .AddText([
                    (RV.MV(Reg.a0, Reg.r(env.Target)), "Copy to a0 for printing")
                    (RV.LI(Reg.a7, 4), "RARS syscall: PrintString")
                    (RV.ECALL, "")
                ])
                ++ (afterSysCall [Reg.a0] [])
        | t ->
            failwith $"BUG: Print codegen invoked on unsupported type %O{t}"

    | PrintLn(arg) ->
        // Recycle codegen for Print above, then also output a newline
        (doCodegen env {node with Expr = Print(arg)})
        ++ (beforeSysCall [Reg.a0] [])
            .AddText([
                (RV.LI(Reg.a7, 11), "RARS syscall: PrintChar")
                (RV.LI(Reg.a0, int('\n')), "Character to print (newline)")
                (RV.ECALL, "")
            ])
            ++ (afterSysCall [Reg.a0] [])

    | If(condition, ifTrue, ifFalse) ->
        /// Label to jump to when the 'if' condition is true
        let labelTrue = Util.genSymbol "if_true"
        /// Label to mark the end of the if..then...else code
        let labelEnd = Util.genSymbol "if_end"
        // Compile the 'if' condition, then jump to 'labelTrue' if the result is
        // true (non-zero). Otherwise, keep executing the 'ifFalse' branch, and
        // then jump to 'labelEnd' (thus skipping the code under 'labelTrue')
        (doCodegen env condition)
            .AddText(RV.BNEZ(Reg.r(env.Target), labelTrue),
                     "Jump when 'if' condition is true")
            ++ (doCodegen env ifFalse)
                .AddText([ (RV.J(labelEnd),
                            "Jump to skip the 'true' branch of 'if' code")
                           (RV.LABEL(labelTrue), "") ])
                ++ (doCodegen env ifTrue)
                    .AddText(RV.LABEL(labelEnd))

    | Seq(nodes) ->
        // We collect the code of each sequence node by folding over all nodes
        let folder (asm: Asm) (node: TypedAST) =
            asm ++ (doCodegen env node)
        List.fold folder (Asm()) nodes

    | Ascription(_, node) ->
        // A type ascription does not produce code --- but the type-annotated
        // AST node does
        doCodegen env node

    | Assertion(arg) ->
        /// Label to jump to when the assertion is true
        let passLabel = Util.genSymbol "assert_true"
        // Check the assertion, and jump to 'passLabel' if it is true;
        // otherwise, fail
        (doCodegen env arg)
            .AddText([
                (RV.ADDI(Reg.r(env.Target), Reg.r(env.Target), Imm12(-1)), "")
                (RV.BEQZ(Reg.r(env.Target), passLabel), "Jump if assertion OK")
                (RV.LI(Reg.a7, 93), "RARS syscall: Exit2")
                (RV.LI(Reg.a0, assertExitCode), "Assertion violation exit code")
                (RV.ECALL, "")
                (RV.LABEL(passLabel), "")
            ])

    // Special case for compiling a function with a given name in the input
    // source file. We recognise this case by checking whether the 'Let...'
    // declares 'name' as a Lambda expression with a TFun type
    | Let(name, _,
          {Node.Expr = Lambda(args, body);
           Node.Type = TFun(targs, _)}, scope) ->
        /// Assembly label to mark the position of the compiled function body.
        /// For readability, we make the label similar to the function name
        let funLabel = Util.genSymbol $"fun_%s{name}"

        /// Names of the lambda term arguments
        let (argNames, _) = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs
        /// Compiled function body
        let bodyCode = compileFunction argNamesTypes body env
        
        /// Compiled function code where the function label is located just
        /// before the 'bodyCode', and everything is placed at the end of the
        /// Text segment (i.e. in the "PostText")
        let funCode =
            (Asm(RV.LABEL(funLabel), $"Code for function '%s{name}'")
                ++ bodyCode).TextToPostText

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let varStorage2 = env.VarStorage.Add(name, Storage.Label(funLabel))

        // Finally, compile the 'let...'' scope with the newly-defined function
        // label in the variables storage, and append the 'funCode' above. The
        // 'scope' code leaves its result in the the 'let...' target register
        (doCodegen {env with VarStorage = varStorage2} scope)
            ++ funCode

    | Let(name, _, init, scope) ->
        /// 'let...' initialisation code, which leaves its result in the
        /// 'target' register (which we overwrite at the end of the 'scope'
        /// execution)
        
        let initCode = doCodegen env  init
        let isTopLevel = env.AtTopLevel
        let env =
            match isTopLevel with
            | true ->
                let storage = env.VarStorage.Add(name, Storage.Label("label_var_%s{name}"))
                {env with VarStorage =storage}
            | false ->
                env
        match init.Type with
        | t when (isSubtypeOf init.Env t TUnit) ->
            // The 'init' produces a unit value, i.e. nothing: we can keep using
            // the same target registers, and we don't need to update the
            // variables-to-registers mapping.
            initCode ++ (doCodegen env scope)
        | t when (isSubtypeOf init.Env t TFloat) ->
            /// Target register for compiling the 'let' scope
            let scopeTarget = env.FPTarget + 1u
            /// Variable storage for compiling the 'let' scope
           

            let scopeVarStorage =
                env.VarStorage.Add(name, Storage.FPReg(FPReg.r(env.FPTarget)))
            /// Environment for compiling the 'let' scope
            let scopeEnv = { env with FPTarget = scopeTarget
                                      VarStorage = scopeVarStorage
                                      AtTopLevel = false }
            initCode
                ++ (doCodegen scopeEnv scope)
                    .AddText(RV.FMV_S(FPReg.r(env.FPTarget),
                                      FPReg.r(scopeTarget)),
                             "Move 'let' scope result to 'let' target register")
        | _ ->  // Default case for integer-like initialisation expressions
            /// Target register for compiling the 'let' scope
            let scopeTarget = env.Target + 1u
            /// Variable storage for compiling the 'let' scope
            let scopeVarStorage =
                env.VarStorage.Add(name, Storage.Reg(Reg.r(env.Target)))
            /// Environment for compiling the 'let' scope
            let scopeEnv = { env with Target = scopeTarget
                                      VarStorage = scopeVarStorage
                                      AtTopLevel = false }
            initCode
                ++ (doCodegen scopeEnv scope)
                    .AddText(RV.MV(Reg.r(env.Target), Reg.r(scopeTarget)),
                             "Move 'let' scope result to 'let' target register")

    | LetMut(name, tpe, init, scope) ->
        // The code generation is not different from 'let...', so we recycle it
        doCodegen env {node with Expr = Let(name, tpe, init, scope)}

    | LetRec(name, _,
          {Node.Expr = Lambda(args, body);
           Node.Type = TFun(targs, _)}, scope) ->
          /// Assembly label to mark the position of the compiled function body.
        /// For readability, we make the label similar to the function name
        let funLabel = Util.genSymbol $"fun_%s{name}"

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let varStorage2 = env.VarStorage.Add(name, Storage.Label(funLabel))

        /// Names of the lambda term arguments
        let (argNames, _) = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs
        /// Compiled function body
        let bodyCode = compileFunction argNamesTypes body {env with VarStorage = varStorage2}
        
        /// Compiled function code where the function label is located just
        /// before the 'bodyCode', and everything is placed at the end of the
        /// Text segment (i.e. in the "PostText")
        let funCode =
            (Asm(RV.LABEL(funLabel), $"Code for function '%s{name}'")
                ++ bodyCode).TextToPostText

        // Finally, compile the 'let...'' scope with the newly-defined function
        // label in the variables storage, and append the 'funCode' above. The
        // 'scope' code leaves its result in the the 'let...' target register
        (doCodegen {env with VarStorage = varStorage2} scope)
            ++ funCode
    
    | LetRec(name, tpe, init, scope) -> 
        doCodegen env {node with Expr = Let(name, tpe, init, scope)}

    | Assign(lhs, rhs) 
    | AddAsg(lhs, rhs)
    | MinAsg(lhs, rhs) ->

        match lhs.Expr with
        | Var(name) ->
            /// Code for the 'rhs', leaving its result in the target register
            let rhsCode = doCodegen env rhs
            match (env.VarStorage.TryFind name) with
            | Some(Storage.Reg(reg)) ->
                rhsCode.AddText(RV.MV(reg, Reg.r(env.Target)),
                                $"Assignment to variable %s{name}")
            | Some(Storage.FPReg(reg)) ->
                rhsCode.AddText(RV.FMV_S(reg, FPReg.r(env.FPTarget)),
                                $"Assignment to variable %s{name}")
            | Some(Storage.Frame(offset)) ->
                rhsCode.AddText(RV.LW(Reg.r(env.Target), Imm12(offset), Reg.fp),
                                $"Assignment to variable %s{name}")
            | Some(Storage.Label(label)) ->
                rhsCode.AddText(RV.LA(Reg.r(env.Target), label),
                                $"Assignment to variable %s{name}")
            // | Some(Storage.Label(_)) as st ->
            //     failwith $"BUG: variable %s{name} has unexpected storage %O{st}"
            | None -> failwith $"BUG: variable without storage: %s{name}"
        | FieldSelect(target, field) ->
            /// Assembly code for computing the 'target' object of which we are
            /// selecting the 'field'.  We write the computation result (which
            /// should be a struct memory address) in the target register.
            let selTargetCode = doCodegen env target
            /// Code for the 'rhs', leaving its result in the target+1 register
            let rhsCode = doCodegen {env with Target = env.Target + 1u} rhs

            match (expandType target.Env target.Type) with
            | TStruct(fields) ->
                /// Names of the struct fields
                let (fieldNames, _) = List.unzip fields
                /// Offset of the selected struct field from the beginning of
                /// the struct
                let offset = List.findIndex (fun f -> f = field) fieldNames
                /// Assembly code that performs the field value assignment
                let assignCode =
                    match rhs.Type with
                    | t when (isSubtypeOf rhs.Env t TUnit)
                        -> Asm() // Nothing to do
                    | t when (isSubtypeOf rhs.Env t TFloat) ->
                        Asm(RV.FSW_S(FPReg.r(env.FPTarget), Imm12(offset * 4),
                                     Reg.r(env.Target)),
                            $"Assigning value to struct field '%s{field}'")
                    | _ ->
                        Asm([(RV.SW(Reg.r(env.Target + 1u), Imm12(offset * 4),
                                    Reg.r(env.Target)),
                              $"Assigning value to struct field '%s{field}'")
                             (RV.MV(Reg.r(env.Target), Reg.r(env.Target + 1u)),
                              "Copying assigned value to target register")])
                // Put everything together
                selTargetCode ++ rhsCode ++ assignCode
            | t ->
                failwith $"BUG: field selection on invalid object type: %O{t}"
        | ArrayElement(target, index) ->
            /// Assembly code for computing the 'target' array of which we are
            /// selecting the 'index' element. We write the computation result
            /// (which should be an array memory address) in the target register.
            let selTargetCode = Asm(RV.COMMENT("Array element assignment begin")) ++ (doCodegen env target).AddText([
                RV.LW(Reg.r(env.Target + 4u), Imm12(4), Reg.r(env.Target)), "Copying array length to target register + 4"
                RV.LW(Reg.r(env.Target), Imm12(0), Reg.r(env.Target)), "Copying array address to target register"
                ])

            /// Assembly code for computing the 'index' of the array element
            /// that we are selecting. We write the computation result, the index (which
            /// should be an integer) in the target+1 register.
            let indexCode = Asm(RV.COMMENT("Index begin")) ++ (doCodegen {env with Target = env.Target + 1u} index)

            // Check if index is out of bounds
            // env.Target + 4u contains the length of the array
            // env.Target + 1u contains the index
            let checkLesThenLengthLabel = Util.genSymbol $"index_ok"

            let checkLesThenLength = Asm([
                    RV.BLT(Reg.r(env.Target + 1u), Reg.r(env.Target + 4u), checkLesThenLengthLabel), "Check if index less then length"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "Load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(checkLesThenLengthLabel), "Index is ok"
                ])

            // Check index >= 0
            let checkBiggerThenZeroLabel = Util.genSymbol $"index_ok"
            let checkBiggerThenZero = Asm([
                    RV.LI(Reg.a7, 0), "Set a7 to 0"
                    RV.BGE(Reg.r(env.Target + 1u), Reg.a7, checkBiggerThenZeroLabel), "Check if index >= 0"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(checkBiggerThenZeroLabel), "Index is ok"
                ])

            /// Assembly code for computing the 'rhs' value that we are
            /// assigning to the array element. We write the computation result
            /// (which should be an integer) in the target+2 register.
            let rhsCode = Asm(RV.COMMENT("Right hand side begin")) ++ (doCodegen {env with Target = env.Target + 2u} rhs)

            let assignCode = 
                    Asm([(RV.LI(Reg.r(env.Target + 3u), 4), "Loading size of array element")
                         (RV.MUL(Reg.r(env.Target + 1u), Reg.r(env.Target + 1u), Reg.r(env.Target + 3u)), "Multiplying index by size of array element")
                         (RV.ADD(Reg.r(env.Target), Reg.r(env.Target), Reg.r(env.Target + 1u)), "Adding index to array address")
                         (RV.SW(Reg.r(env.Target + 1u), Imm12(0), Reg.r(env.Target)), "Copying index to array address")
                         (RV.SW(Reg.r(env.Target + 2u), Imm12(0), Reg.r(env.Target)),"Assigning value to array element")
                         (RV.MV(Reg.r(env.Target), Reg.r(env.Target + 2u)), "Copying assigned value to target register")])

            selTargetCode ++ indexCode ++ checkLesThenLength ++ checkBiggerThenZero ++ rhsCode ++ assignCode
        | _ ->
            failwith ($"BUG: assignment to invalid target:%s{Util.nl}"
                      + $"%s{PrettyPrinter.prettyPrint lhs}")
                      
    | ArraySlice(target, start, ending) -> 
        let startIndex = (doCodegen env start)
        let endIndex = (doCodegen {env with Target = env.Target + 1u} ending)

        let start_index_ok = Util.genSymbol $"start_index_ok"
        // check that start index is bigger then 0
        let checkStartIndex = Asm([
                    RV.LI(Reg.a7, 0), "Set a7 to 0"
                    RV.BGE(Reg.r(env.Target), Reg.a7, start_index_ok), "Check if start index >= 0"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(start_index_ok), "start index is ok"
                ])

        let len = Asm(RV.COMMENT("Array slice begin")) ++ startIndex ++ checkStartIndex ++ endIndex.AddText([
            // compute the length of the slice
            RV.SUB(Reg.r(env.Target + 3u), Reg.r(env.Target + 1u), Reg.r(env.Target)), "Subtracting start index from end index"
        ])

        let length_ok = Util.genSymbol $"length_ok"

        // check that length is bigger then 1
        let checkLength = Asm([
                    RV.LI(Reg.r(env.Target + 4u), 0), ""
                    RV.BLT(Reg.r(env.Target + 4u), Reg.r(env.Target + 3u), length_ok), "Check if length is less then 1"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "Load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(length_ok), "length is ok"
                ])

        let checkSize = len ++ checkLength 

        // Allocate space for the array struct on the heap
        let structAllocCode =
            (beforeSysCall [Reg.a0] [])
                .AddText([
                    (RV.LI(Reg.a0, 2 * 4), "Amount of memory to allocate for the array struct {data, length} (in bytes)")
                    (RV.LI(Reg.a7, 9), "RARS syscall: Sbrk")
                    (RV.ECALL, "")
                    (RV.MV(Reg.r(env.Target + 1u), Reg.a0), "Move syscall result (struct mem address) to target + 1u")
                ])
                ++ (afterSysCall [Reg.a0] [])

        // t0 have the address of the array struct
        // Initialize the length field of the array struct
        let lengthCode = Asm(RV.MV(Reg.t6, Reg.r(env.Target + 1u)), "Move array struct adrress to t6").AddText([
            RV.SW(Reg.r(env.Target + 3u), Imm12(4), Reg.t6), "Initialize array length field"
            RV.MV(Reg.t4, Reg.r(env.Target)), "Move length to t4"
        ])

        // Store the array data pointer in the data field of the array struct
        let targetCode = (doCodegen {env with Target = env.Target - 1u} target)

        // t1 contains end and start index, t0 contains array struct address
        let arrayReg = Reg.r(env.Target - 1u)

        let checkStartIndexLabel = Util.genSymbol $"start_index_ok"
        let checkStartIndex = (doCodegen env start).AddText([
                    RV.LW(Reg.r(env.Target + 2u), Imm12(4), arrayReg), "Load length to t5"
                    RV.BLE(Reg.r(env.Target), Reg.r(env.Target + 2u), checkStartIndexLabel), "Check if start_index < length_of_original_array"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(checkStartIndexLabel), "start index is ok"
                ])

        // check that end index is less then length of original array
        let checkEndIndexLabel = Util.genSymbol $"end_index_ok"
        let checkEndIndex = (doCodegen env ending).AddText([
                    RV.LW(Reg.r(env.Target + 2u), Imm12(4), arrayReg), "Load length to t5"
                    RV.BLE(Reg.r(env.Target), Reg.r(env.Target + 2u), checkEndIndexLabel), "Check if end_index < length_of_original_array"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(checkEndIndexLabel), "end index is ok"
                ])        
        
        let dataInitCode = Asm([
                // Initialize array data pointer field with the address of the array data with the start offset * 4 added
                RV.LI(Reg.a0, 4), "(in bytes)"
                RV.MUL(Reg.t4, Reg.t4, Reg.a0), "Multiply start index by 4"
                RV.ADD(Reg.t5, Reg.t5, Reg.t4), "Add start index to array struct address"
                RV.SW(Reg.t5, Imm12(0), Reg.t6), "Initialize array data pointer field"
                // move the address of the array struct to the target register
                RV.MV(Reg.r(env.Target), Reg.t6), "Move array struct address to target"
             ])

        // Combine all the generated code
        checkSize ++ structAllocCode ++ lengthCode ++ targetCode ++ checkStartIndex ++ checkEndIndex ++ dataInitCode

    | While(cond, body) ->
        /// Label to mark the beginning of the 'while' loop
        let whileBeginLabel = Util.genSymbol "while_loop_begin"
        /// Label to mark the end of the 'while' loop
        let whileEndLabel = Util.genSymbol "while_loop_end"
        // Check the 'while' condition, jump to 'whileEndLabel' if it is false
        Asm(RV.LABEL(whileBeginLabel))
            ++ (doCodegen env cond)
                .AddText(RV.BEQZ(Reg.r(env.Target), whileEndLabel),
                         "Jump if 'while' loop condition is false")
            ++ (doCodegen env body)
            .AddText([
                (RV.J(whileBeginLabel), "Next iteration of the 'while' loop")
                (RV.LABEL(whileEndLabel), "")
            ])

    | DoWhile(cond, body) ->
        (doCodegen env body) ++ (doCodegen env {node with Expr = While(cond, body)})

    | For(init, cond, update, body) ->
        (doCodegen env init) ++ (doCodegen env {node with Expr = While(cond, {node with Expr = Seq([body; update])})})

    | Type(_, _, scope) ->
        // A type alias does not produce any code --- but its scope does
        doCodegen env scope

    | Lambda(args, body) ->
        /// Label to mark the position of the lambda term body
        let funLabel = Util.genSymbol "lambda"

        /// Names of the Lambda arguments
        let (argNames, _) = List.unzip args

        /// List of pairs associating each Lambda argument to its type.  We
        /// retrieve the type of each argument by looking into the environment
        /// used to type-check the Lambda 'body'
        let argNamesTypes = List.map (fun a -> (a, body.Env.Vars[a])) argNames

        /// Compiled function body
        let bodyCode = compileFunction argNamesTypes body env
        
        /// Compiled function code where the function label is located just
        /// before the 'bodyCode', and everything is placed at the end of the
        /// text segment (i.e. in the "PostText")
        let funCode =
            (Asm(RV.LABEL(funLabel), "Lambda term (i.e. function instance) code")
                ++ bodyCode).TextToPostText // Move to the end of text segment

        // Finally, load the function address (label) in the target register
        Asm(RV.LA(Reg.r(env.Target), funLabel), "Load lambda function address")
            ++ funCode

    | Application(expr, args) ->
        /// Integer registers to be saved on the stack before executing the
        /// function call, and restored when the function returns.  The list of
        /// saved registers excludes the target register for this application.
        /// Note: the definition of 'saveRegs' uses list comprehension:
        /// https://en.wikibooks.org/wiki/F_Sharp_Programming/Lists#Using_List_Comprehensions
        let saveRegs =
            List.except [Reg.r(env.Target)]
                        (Reg.ra :: [for i in 0u..7u do yield Reg.a(i)]
                         @ [for i in 0u..6u do yield Reg.t(i)])

        /// Assembly code for the expression being applied as a function
        let appTermCode =
            Asm().AddText(RV.COMMENT("Load expression to be applied as a function"))
            ++ (doCodegen env expr)

        /// Indexed list of argument expressions.  We will use the as an offset
        /// (above the current target register) to determine the target register
        /// for compiling each expression.
        let indexedArgs = List.indexed args
        /// Function that compiles an argument (using its index to determine its
        /// target register) and accumulates the generated assembly code
        let compileArg (acc: Asm) (i, arg) =
            acc ++ (doCodegen {env with Target = env.Target + (uint i) + 1u} arg)
        /// Assembly code of all application arguments, obtained by folding over
        /// 'indexedArgs'
        let argsCode = List.fold compileArg (Asm()) indexedArgs

        /// Function that copies the content of a target register (used by
        /// 'compileArgs' and 'argsCode' above) into an 'a' register, using an
        /// index to determine the source and target registers, and accumulating
        /// the generated assembly code
        let copyArg (acc: Asm) (i: int) =
            acc.AddText(RV.MV(Reg.a(uint i), Reg.r(env.Target + (uint i) + 1u)),
                        $"Load function call argument %d{i+1}")

        /// Code that loads the first 8 application arguments into a register 'a', by
        /// copying the contents of the target registers used by 'compileArgs'
        /// and 'argsCode' above. This code folds over the indexes
        /// of arguments (from 0 to maximum the first 8 elements), using 'copyArg' above.
        let argsLengthToCopy = if args.Length <= 8 then args.Length else 8
        let argsLoadCode = List.fold copyArg (Asm()) [0..(argsLengthToCopy-1)]

        /// Code that saves the remaining application arguments (if any) 
        /// into the stack, in reverse order
        let extraRegistersNeeded =
            if args.Length > 8
            then [8..(args.Length-1)] |> List.map (fun i -> Reg.r(env.Target + (uint i) + 1u))
            else []
        let argsSaveCode = saveRegisters (extraRegistersNeeded |> List.rev) []

        /// Code that performs the function call
        let callCode =
            appTermCode
            ++ argsCode // Code to compute each argument of the function call
               .AddText(RV.COMMENT("Before function call: save caller-saved registers"))
               ++ (saveRegisters saveRegs [])
               ++ argsLoadCode // Code to load arg values into arg registers
               ++ argsSaveCode // Code to save arg values into the stack
                  .AddText(RV.JALR(Reg.ra, Imm12(0), Reg.r(env.Target)), "Function call")

        /// Code that handles the function return value (if any)
        let retCode =
            Asm(RV.MV(Reg.r(env.Target), Reg.a0),
                $"Copy function return value to target register")

        // Put everything together, and restore the caller-saved registers,
        // as well as registers used for storing arguments
        callCode
            .AddText(RV.COMMENT("After function call"))
            .AddText(RV.COMMENT("Restore registers used for extra arguments"))
                  ++ (restoreRegisters (extraRegistersNeeded |> List.rev) [])
            ++ retCode
            .AddText(RV.COMMENT("Restore caller-saved registers"))
                  ++ (restoreRegisters saveRegs [])
    | Array(length, data) ->

        let len = (doCodegen env length)

        let length_ok = Util.genSymbol $"length_ok"

        // check that length is bigger then 1
        let checkLength = Asm([
                    RV.LI(Reg.r(env.Target + 1u), 0), ""
                    RV.BLT(Reg.r(env.Target + 1u), Reg.r(env.Target), length_ok), "Check if length is less then 1"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "Load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(length_ok), "length is ok"
                ])

        let checkSize = len ++ checkLength

        // Allocate space for the array struct on the heap
        let structAllocCode =
            (beforeSysCall [Reg.a0] [])
                .AddText([
                    (RV.LI(Reg.a0, 2 * 4), "Amount of memory to allocate for the array struct {data, length} (in bytes)")
                    (RV.LI(Reg.a7, 9), "RARS syscall: Sbrk")
                    (RV.ECALL, "")
                    (RV.MV(Reg.r(env.Target), Reg.a0), "Move syscall result (struct mem address) to target")
                ])
                ++ (afterSysCall [Reg.a0] [])

        // t0 have the address of the array struct
        // Initialize the length field of the array struct
        let lengthCode = Asm(RV.MV(Reg.t6, Reg.r(env.Target)), "Move adrress to t6") ++ (doCodegen env length).AddText([
            RV.SW(Reg.r(env.Target), Imm12(4), Reg.t6), "Initialize array length field"
            RV.MV(Reg.t4, Reg.r(env.Target)), "Move length to t4"
        ])

        // Allocate space for the array data on the heap
        let dataAllocCode =
            (beforeSysCall [Reg.a0] [])
                .AddText([
                    (RV.LI(Reg.a0, 4), "4 (bytes)") //  first load the size of the memory block we want to allocate into register a0, this is length * 4 (in bytes)
                    (RV.MUL(Reg.a0, Reg.a0, Reg.r(env.Target)), "Multiply length * 4 to get array size")
                    (RV.LI(Reg.a7, 9), "RARS syscall: Sbrk")
                    (RV.ECALL, "")
                    (RV.MV(Reg.r(env.Target + 2u), Reg.a0), "Move syscall result (array data mem address) to target+2")
                ])
                ++ (afterSysCall [Reg.a0] [])

        // Store the array data pointer in the data field of the array struct
        let dataInitCode =
             Asm(RV.SW(Reg.r(env.Target + 2u), Imm12(0), Reg.t6), "Initialize array data field").AddText([
                RV.MV(Reg.t5, Reg.r(env.Target + 2u)), "Move array data address to t6"
             ])
            
        // Now t5 have the address of the array data

        let beginLabel = Util.genSymbol "loop_begin"

        // Store the array data in the allocated memory
        let codeGenData = 
            (doCodegen env data)
                .AddText([
                    RV.LI(Reg.a2, 4), "Load the size of each element in the array"
                    RV.LI(Reg.a3, 0), "Load the starting index"
                ])
                .AddText(RV.LABEL(beginLabel))
                .AddText([
                RV.MUL(Reg.r(env.Target + 2u), Reg.a2, Reg.a3), "Calculate the offset (index) from the base address"
                RV.ADD(Reg.r(env.Target + 3u), Reg.t5, Reg.r(env.Target + 2u)), "Calculate the address of the element"
                RV.SW(Reg.r(env.Target), Imm12(0), Reg.r(env.Target + 3u)), "Store the value in the element"
                RV.ADDI(Reg.a3, Reg.a3, Imm12(1)), "Increment the index"
                RV.BLT(Reg.a3, Reg.t4, beginLabel), "Loop if the index is less than the ending index"
                RV.MV(Reg.r(env.Target), Reg.t6), "Move struct array mem address to target register"
            ]).AddText(RV.COMMENT("Allocation done"))

        // Combine all the generated code
        checkSize ++ structAllocCode ++ lengthCode ++ dataAllocCode ++ dataInitCode ++ codeGenData
    | ArrayElement(target, index) ->
        /// Assembly code that computes the address of the array element at the
        /// given index. The address is computed by adding the index to the
        /// address of the first element of the array.
        let arrayAccessCode = (doCodegen env target).AddText([
                RV.LW(Reg.r(env.Target + 1u), Imm12(0), Reg.r(env.Target)), "Load array data pointer"
                RV.LW(Reg.r(env.Target + 4u), Imm12(4), Reg.r(env.Target)), "Copying array length to target register + 4"
            ])

        let indexCode = (doCodegen env index)

        // env.Target contains the index
        let checkLesThenLengthLabel = Util.genSymbol $"index_ok"
        let checkLesThenLength = Asm([
                    RV.BLT(Reg.r(env.Target), Reg.r(env.Target + 4u), checkLesThenLengthLabel), "Check if index less then length"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "Load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(checkLesThenLengthLabel), "Index is ok"
                ])

        // Check index >= 0
        let checkBiggerThenZeroLabel = Util.genSymbol $"index_ok"
        let checkBiggerThenZero = Asm([
                    RV.LI(Reg.a7, 0), "Set a7 to 0"
                    RV.BGE(Reg.r(env.Target), Reg.a7, checkBiggerThenZeroLabel), "Check if index >= 0"
                    RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                    RV.LI(Reg.a0, assertExitCode), "Load exit code"
                    RV.ECALL, "Call exit"
                    RV.LABEL(checkBiggerThenZeroLabel), "Index is ok"
                ])
        
        let readElment = Asm([
                (RV.LI(Reg.t3, 4), "Load the size of each element in the array")
                (RV.MUL(Reg.r(env.Target), Reg.r(env.Target), Reg.t3), "Calculate the offset (index) from the base address")
                // (RV.ADDI(Reg.r(env.Target), Reg.r(env.Target), Imm12(-4)), "Add the offset to the base address")
                (RV.ADD(Reg.r(env.Target), Reg.r(env.Target), Reg.r(env.Target + 1u)), "Compute array element address")
                (RV.LW(Reg.r(env.Target), Imm12(0), Reg.r(env.Target)), "Load array element")
            ])

        // Put everything together: compute array element address
        arrayAccessCode ++ indexCode ++ checkLesThenLength ++ checkBiggerThenZero ++ readElment
    | ArrayLength(target) ->
        /// Assembly code that computes the length of the given array. The
        /// length is stored in the first word of the array struct, so we
        /// simply load that word into the target register. 
        (doCodegen env target).AddText([
                (RV.LW(Reg.r(env.Target), Imm12(4), Reg.r(env.Target)), "Load array length")
            ])
    | Struct(fields) ->
        // To compile a struct, we allocate heap space for the whole struct
        // instance, and then compile its field initialisations one-by-one,
        // storing each result in the corresponding heap location.  The struct
        // heap address will end up in the 'target' register - i.e. the register
        // will contain a pointer to the first element of the structure
        let (fieldNames, fieldInitNodes) = List.unzip fields
        /// Generate the code that initialises a struct field, and accumulates
        /// the result.  This function is folded over all indexed struct fields,
        /// to produce the assembly code that initialises all fields.
        let folder = fun (acc: Asm) (fieldOffset: int, fieldInit: TypedAST) ->
            /// Code that initialises a single struct field.  Each field init
            /// result is compiled by targeting the register (target+1u),
            /// because the 'target' register holds the base memory address of
            /// the struct.  After the init result for a field is computed, we
            /// copy it into its heap location, by adding the field offset
            /// (multiplied by 4, i.e. the word size) to the base struct address
            let fieldInitCode: Asm =
                match fieldInit.Type with
                | t when (isSubtypeOf fieldInit.Env t TUnit) ->
                    Asm() // Nothing to do
                | t when (isSubtypeOf fieldInit.Env t TFloat) ->
                    Asm(RV.FSW_S(FPReg.r(env.FPTarget), Imm12(fieldOffset * 4),
                                 Reg.r(env.Target)),
                        $"Initialize struct field '%s{fieldNames.[fieldOffset]}'")
                | _ ->
                    Asm(RV.SW(Reg.r(env.Target + 1u), Imm12(fieldOffset * 4),
                              Reg.r(env.Target)),
                        $"Initialize struct field '%s{fieldNames.[fieldOffset]}'")
            acc ++ (doCodegen {env with Target = env.Target + 1u} fieldInit)
                ++ fieldInitCode
        /// Assembly code for initialising each field of the struct, by folding
        /// the 'folder' function above over all indexed struct fields (we use
        /// the index to know the offset of a field from the beginning of the
        /// struct)
        let fieldsInitCode =
            List.fold folder (Asm()) (List.indexed fieldInitNodes)

        /// Assembly code that allocates space on the heap for the new
        /// structure, through an 'Sbrk' system call.  The size of the structure
        /// is computed by multiplying the number of fields by the word size (4)
        let structAllocCode =
            (beforeSysCall [Reg.a0] [])
                .AddText([
                    (RV.LI(Reg.a0, fields.Length * 4), "Amount of memory to allocate for a struct (in bytes)")
                    (RV.LI(Reg.a7, 9), "RARS syscall: Sbrk")
                    (RV.ECALL, "")
                    (RV.MV(Reg.r(env.Target), Reg.a0), "Move syscall result (struct mem address) to target")
                ])
                ++ (afterSysCall [Reg.a0] [])

        // Put everything together: allocate heap space, init all struct fields
        structAllocCode ++ fieldsInitCode

    | FieldSelect(target, field) ->
        // To compile a field selection, we first execute the 'target' object of
        // the field selection, whose code is expected to leave a struct memory
        // address in the environment's 'target' register; then use the 'target'
        // type to determine the memory offset where the selected field is
        // located, and retrieve its value.

        /// Generated code for the target object whose field is being selected
        let selTargetCode = doCodegen env target
        /// Assembly code to access the struct field in memory (depending on the
        /// 'target' type) and leave its value in the target register
        let fieldAccessCode =
            match (expandType node.Env target.Type) with
            | TStruct(fields) ->
                let (fieldNames, fieldTypes) = List.unzip fields
                let offset = List.findIndex (fun f -> f = field) fieldNames
                match fieldTypes.[offset] with
                | t when (isSubtypeOf node.Env t TUnit) ->
                    Asm() // Nothing to do
                | t when (isSubtypeOf node.Env t TFloat) ->
                    Asm(RV.FLW_S(FPReg.r(env.FPTarget), Imm12(offset * 4),
                                 Reg.r(env.Target)),
                        $"Retrieve value of struct field '%s{field}'")
                | _ ->
                    Asm(RV.LW(Reg.r(env.Target), Imm12(offset * 4),
                              Reg.r(env.Target)),
                        $"Retrieve value of struct field '%s{field}'")
            | t ->
                failwith $"BUG: FieldSelect codegen on invalid target type: %O{t}"

        // Put everything together: compile the target, access the field
        selTargetCode ++ fieldAccessCode

    | UnionCons(label, expr) ->

        // allocate space for union case on heap
        let unionAllocCode =
            (beforeSysCall [Reg.a0] [])
                .AddText([
                    (RV.LI(Reg.a0, 2 * 4), "Amount of memory to allocate on heap for one label (in bytes)")
                    (RV.LI(Reg.a7, 9), "RARS syscall: Sbrk")
                    (RV.ECALL, "")
                    (RV.MV(Reg.r(env.Target), Reg.a0), "Move syscall result to target (pointer to label)")
                ])
                ++ (afterSysCall [Reg.a0] [])

        // compute label id
        let id = Util.genSymbolId label
        // create node for label
        let idNode = {node with Expr = IntVal(id)}

        // place label on heap
        let labelCode = (doCodegen {env with Target = env.Target + 1u} idNode).AddText([
            (RV.SW(Reg.r(env.Target + 1u), Imm12(0), Reg.r(env.Target)), "Store label on heap")
        ])

        // t2 = pointer to label
        // place value on heap
        let nodeCode = (doCodegen {env with Target = env.Target + 2u} expr).AddText([
            (RV.SW(Reg.r(env.Target + 2u), Imm12(4), Reg.r(env.Target)), "Store node on heap")
        ])
        
        unionAllocCode ++ labelCode ++ nodeCode
    | Match(target, cases) -> 
        let selTargetCode = doCodegen env target
        
        let (labels, vars, exprs) = List.unzip3 cases
        let indexedLabels = List.indexed labels

        let matchEndLabel = Util.genSymbol $"match_end"

        let folder = 
            fun (acc: Asm) (i: int * string) ->
                let (index, label) = i
                let id = Util.genSymbolId label
                let expr = exprs.[index]
                let var = vars.[index]

                let scopeTarget = env.Target
                /// Variable storage for compiling the 'case' scope
                let scopeVarStorage =
                    env.VarStorage.Add(var, Storage.Reg(Reg.r(env.Target)))
                /// Environment for compiling the 'case' scope
                let scopeEnv = {env with Target = scopeTarget; VarStorage = scopeVarStorage}

                let caseEndLabel = Util.genSymbol $"case_end"

                let matchCode = Asm([
                    RV.LI(Reg.r(env.Target + 2u), id), $"Load label id: {id}, label: {label}" 
                    RV.LW(Reg.r(env.Target + 3u), Imm12(0), Reg.r(env.Target)), "Load label id from heap"
                    RV.BNE(Reg.r(env.Target + 3u), Reg.r(env.Target + 2u), caseEndLabel), "Compare label id with target (Branch if Not Equal)" 
                    RV.LW(Reg.r(env.Target), Imm12(4), Reg.r(env.Target)), "Load value from heap"
                ])

                let exprCode = (doCodegen {scopeEnv with Target = env.Target} expr).AddText([
                        RV.J(matchEndLabel), "Jump to match end" // case was executed jump to end
                        RV.LABEL(caseEndLabel), $"Case end id: {id}, label: {label}"
                    ])
            
                acc ++ matchCode ++ exprCode

        let casesInitCode =
            (List.fold folder (Asm()) indexedLabels).AddText([
                // failer case - if no case was executed
                RV.LI(Reg.a7, 93), "RARS syscall: Exit2"
                RV.LI(Reg.a0, assertExitCode), "Load exit code"
                RV.ECALL, "Call exit"
                // end of match
                RV.LABEL(matchEndLabel), "match end label"
        ])

        selTargetCode ++ casesInitCode
    | Pointer(_) ->
        failwith "BUG: pointers cannot be compiled (by design!)"

/// Generate code to save the given registers on the stack, before a RARS system
/// call. Register a7 (which holds the system call number) is backed-up by
/// default, so it does not need to be specified when calling this function.
and internal beforeSysCall (regs: List<Reg>) (fpregs: List<FPReg>): Asm =
    Asm(RV.COMMENT("Before system call: save registers"))
        ++ (saveRegisters (Reg.a7 :: regs) fpregs)


/// Generate code to restore the given registers from the stack, after a RARS
/// system call. Register a7 (which holds the system call number) is restored
/// by default, so it does not need to be specified when calling this function.
and internal afterSysCall (regs: List<Reg>) (fpregs: List<FPReg>): Asm =
    Asm(RV.COMMENT("After system call: restore registers"))
        ++ (restoreRegisters (Reg.a7 :: regs) fpregs)


/// Generate code to save the given lists of registers by using increasing
/// offsets from the stack pointer register (sp).
and internal saveRegisters (rs: List<Reg>) (fprs: List<FPReg>): Asm =
    /// Generate code to save standard registers by folding over indexed 'rs'
    let regSave (asm: Asm) (i, r) = asm.AddText(RV.SW(r, Imm12(i * 4), Reg.sp))
    /// Code to save standard registers
    let rsSaveAsm = List.fold regSave (Asm()) (List.indexed rs)

    /// Generate code to save floating point registers by folding over indexed
    /// 'fprs', and accumulating code on top of 'rsSaveAsm' above. Notice that
    /// we use the length of 'rs' as offset for saving on the stack, since those
    /// stack locations are already used to save 'rs' above.
    let fpRegSave (asm: Asm) (i, r) =
        asm.AddText(RV.FSW_S(r, Imm12((i + rs.Length) * 4), Reg.sp))
    /// Code to save both standard and floating point registers
    let regSaveCode = List.fold fpRegSave rsSaveAsm (List.indexed fprs)

    // Put everything together: update the stack pointer and save the registers
    Asm(RV.ADDI(Reg.sp, Reg.sp, Imm12(-4 * (rs.Length + fprs.Length))),
        "Update stack pointer to make room for saved registers")
      ++ regSaveCode


/// Generate code to restore the given lists of registers, that are assumed to
/// be saved with increasing offsets from the stack pointer register (sp)
and internal restoreRegisters (rs: List<Reg>) (fprs: List<FPReg>): Asm =
    /// Generate code to restore standard registers by folding over indexed 'rs'
    let regLoad (asm: Asm) (i, r) = asm.AddText(RV.LW(r, Imm12(i * 4), Reg.sp))
    /// Code to restore standard registers
    let rsLoadAsm = List.fold regLoad (Asm()) (List.indexed rs)

    /// Generate code to restore floating point registers by folding over
    /// indexed 'fprs', and accumulating code on top of 'rsLoadAsm' above.
    /// Notice that we use the length of 'rs' as offset for saving on the stack,
    /// since those stack locations are already used to save 'rs' above.
    let fpRegLoad (asm: Asm) (i, r) =
        asm.AddText(RV.FLW_S(r, Imm12((i + rs.Length) * 4), Reg.sp))
    // Code to restore both standard and floating point registers
    let regRestoreCode = List.fold fpRegLoad rsLoadAsm (List.indexed fprs)

    // Put everything together: restore the registers and then the stack pointer
    regRestoreCode
        .AddText(RV.ADDI(Reg.sp, Reg.sp, Imm12(4 * (rs.Length + fprs.Length))),
                 "Restore stack pointer after register restoration")


/// Compile a function instance with the given (optional) name, arguments, and
/// body, and using the given environment.  This function places all the
/// assembly code it generates in the Text segment (hence, this code may need
/// to be moved afterwards).
and internal compileFunction (args: List<string * Type>)
                             (body: TypedAST)
                             (env: CodegenEnv): Asm =
    /// List of indexed arguments: we use the index as the number of the 'a'
    /// register that holds the argument
    let indexedArgs = List.indexed args
    /// Folder function that assigns storage information to function arguments:
    /// it assigns an 'a' register or stack position at given offset from the 'fp' register
    /// to each function argument, and accumulates the result in a mapping (that will be used as env.VarStorage)
    let folder (acc: Map<string, Storage>) (i, (var, _tpe)) =
        acc.Add(var, 
            if i <= 7 then Storage.Reg(Reg.a((uint)i))
            else Storage.Frame(4 * (args.Length - i - 1)))

    /// Updated storage information including function arguments
    let varStorage2 = List.fold folder env.VarStorage indexedArgs

    /// Code for the body of the function, using the newly-created
    /// variable storage mapping 'varStorage2'.  NOTE: the function body
    /// compilation restarts the target register numbers from 0.  Consequently,
    /// the function body result (i.e. the function return value) will be stored
    /// in Reg.r(0) or FPReg.r(0) (depending on its type); when the function
    /// ends, we need to move that result into the function return value
    /// register 'a0' or 'fa0'.
    let bodyCode =
        let env = {Target = 0u; FPTarget = 0u; VarStorage = varStorage2; AtTopLevel = true;}
        doCodegen env body
    /// Code to move the body result into the function return value register
    let returnCode =
        Asm(RV.MV(Reg.a0, Reg.r(0u)),
            "Move result of function into return value register")

    /// Integer registers to save before executing the function body.
    /// Note: the definition of 'saveRegs' uses list comprehension:
    /// https://en.wikibooks.org/wiki/F_Sharp_Programming/Lists#Using_List_Comprehensions
    let saveRegs = [for i in 0u..11u do yield Reg.s(i)]

    // Finally, we put together the full code for the function
    Asm(RV.COMMENT("Funtion prologue begins here"))
            .AddText(RV.COMMENT("Save callee-saved registers"))
        ++ (saveRegisters saveRegs [])
            .AddText(RV.ADDI(Reg.fp, Reg.sp, Imm12(saveRegs.Length * 4)),
                     "Update frame pointer for the current function")
            .AddText(RV.COMMENT("End of function prologue.  Function body begins"))
        ++ bodyCode
            .AddText(RV.COMMENT("End of function body.  Function epilogue begins"))
        ++ returnCode
            .AddText(RV.COMMENT("Restore callee-saved registers"))
            ++ (restoreRegisters saveRegs [])
                .AddText(RV.JR(Reg.ra), "End of function, return to caller")


/// Generate RISC-V assembly for the given AST.
let codegen (node: TypedAST): RISCV.Asm =
    /// Initial codegen environment, targeting generic registers 0 and without
    /// any variable in the storage map
    let env = {Target = 0u; FPTarget = 0u; VarStorage =  Map[]; AtTopLevel = true;}
    Asm(RV.MV(Reg.fp, Reg.sp), "Initialize frame pointer")
    ++ (doCodegen env node)
        .AddText([
            (RV.LI(Reg.a7, 10), "RARS syscall: Exit")
            (RV.ECALL, "Successful exit with code 0")
        ])
