// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Alceste Scalas <alcsc@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

/// Interpreter for Hygge programs.
module Interpreter

open AST


/// Does the given AST node represent a value?
let rec isValue (node: Node<'E,'T>): bool =
    match node.Expr with
    | UnitVal
    | BoolVal(_)
    | IntVal(_)
    | FloatVal(_)
    | StringVal(_) -> true
    | Lambda(_, _) -> true
    | Pointer(_) -> true
    | _ -> false


/// Type for the runtime heap: a map from memory addresses to values.  The type
/// parameters have the same meaning of the corresponding ones in
/// AST.Node<'E,'T>: they allow the heap to hold generic instances of
/// AST.Node<'E,'T>.
type internal Heap<'E,'T> = Map<uint, Node<'E,'T>>


/// Runtime environment for the interpreter.  The type parameters have the same
/// meaning of the corresponding ones in AST.Node<'E,'T>: they allow the
/// environment to hold generic instances of AST.Node<'E,'T>.
type internal RuntimeEnv<'E,'T> = {
    /// Function called to read a line when evaluating 'ReadInt' and 'ReadFloat'
    /// AST nodes.
    Reader: Option<unit -> string>
    /// Function called to produce an output when evaluating 'Print' and
    /// 'PrintLn' AST nodes.
    Printer: Option<string -> unit>
    /// Mutable local variables: mapping from their name to their current value.
    Mutables: Map<string, Node<'E,'T>>
    /// Runtime heap, mapping memory addresses to values.
    Heap: Heap<'E,'T>
    /// Pointer information, mapping memory addresses to lists of structure
    /// fields.
    PtrInfo: Map<uint, List<string>>
} with override this.ToString(): string =
        let folder str addr n = str + $"      0x%x{addr}: %s{PrettyPrinter.prettyPrint n}"
        let heapStr = if this.Heap.IsEmpty then "{}"
                      else "{" + Util.nl + (Map.fold folder "" this.Heap) + "    }"
        let folder str addr fields = str + $"      0x%x{addr}: %O{fields}%s{Util.nl}"
        let ptrInfoStr = if this.PtrInfo.IsEmpty then "{}"
                         else "{" + Util.nl + (Map.fold folder "" this.PtrInfo) + "    }"
        $"  - Reader: %O{this.Reader}"
          + $"%s{Util.nl}  - Printer: %O{this.Printer}"
          + $"%s{Util.nl}  - Mutables: %s{Util.formatMap this.Mutables}"
          + $"%s{Util.nl}  - Heap: %s{heapStr}"
          + $"%s{Util.nl}  - PtrInfo: %s{ptrInfoStr}"


/// Attempt to reduce the given AST node by one step, using the given runtime
/// environment.  If a reduction is possible, return the reduced node and an
/// updated runtime environment; otherwise, return None.
let rec internal reduce (env: RuntimeEnv<'E,'T>)
                        (node: Node<'E,'T>): Option<RuntimeEnv<'E,'T> * Node<'E,'T>> =
    match node.Expr with
    | UnitVal
    | BoolVal(_)
    | IntVal(_)
    | FloatVal(_)
    | StringVal(_) -> None

    | Var(name) when env.Mutables.ContainsKey(name) ->
        Some(env, env.Mutables[name])
    | Var(_) -> None

    | Max(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = IntVal(max v1 v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = FloatVal(max v1 v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Max(lhs', rhs')})
            | None -> None

    | Min(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = IntVal(min v1 v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = FloatVal(min v1 v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Min(lhs', rhs')})
            | None -> None
            
    | Lambda(_, _) -> None

    | Pointer(_) -> None

    | Mult(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = IntVal(v1 * v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = FloatVal(v1 * v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Mult(lhs', rhs')})
            | None -> None
    
    | Div(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = IntVal(v1 / v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = FloatVal(v1 / v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Div(lhs', rhs')})
            | None -> None

    | Rem(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = IntVal(v1 % v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Rem(lhs', rhs')})
            | None -> None

    | Add(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = IntVal(v1 + v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = FloatVal(v1 + v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Add(lhs', rhs')})
            | None -> None

    | Sub(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) -> Some(env, {node with Expr = IntVal(v1 - v2)})
        | (FloatVal(v1), FloatVal(v2)) -> Some(env, {node with Expr = FloatVal(v1 - v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') -> Some(env', {node with Expr = Sub(lhs', rhs')})
            | None -> None
            
    | And(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (BoolVal(v1), BoolVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 && v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = And(lhs', rhs')})
            | None -> None

    | Or(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (BoolVal(v1), BoolVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 || v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Or(lhs', rhs')})
            | None -> None

    | Xor(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (BoolVal(v1), BoolVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 <> v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Xor(lhs', rhs')})
            | None -> None

    | ShortAnd(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (BoolVal(false), _) ->
            Some(env, {node with Expr = BoolVal(false)})
        | (BoolVal(true), e) ->
            Some(env, {node with Expr = e})
        | (_, _) ->
            match (reduce env lhs) with
            | Some(env', lhs') ->
                Some(env', {node with Expr = ShortAnd(lhs', rhs)})
            | None -> None

    | ShortOr(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (BoolVal(true), _) ->
            Some(env, {node with Expr = BoolVal(true)})
        | (BoolVal(false), e) ->
            Some(env, {node with Expr = e})
        | (_, _) ->
            match (reduce env lhs) with
            | Some(env', lhs') ->
                Some(env', {node with Expr = ShortOr(lhs', rhs)})
            | None -> None

    | Not(arg) ->
        match arg.Expr with
        | BoolVal(v) ->
            Some(env, {node with Expr = BoolVal(not v)})
        | _ ->
            match (reduce env arg) with
            | Some(env', arg2) ->
                Some(env', {node with Expr = Not(arg2)})
            | None -> None

    | CSIncr(arg) ->
        match arg.Expr with 
        | IntVal(v) ->
            Some(env, {node with Expr = IntVal(v+1)})
        | FloatVal(v) ->
            Some(env, {node with Expr = FloatVal(v+1.0f)})
        | _ ->
            match (reduce env arg) with
            | Some(env', arg2) ->
                Some(env', {node with Expr = CSIncr(arg2)})
            | None -> None
    | CSDcr(arg) ->
        match arg.Expr with 
        | IntVal(v) ->
            Some(env, {node with Expr = IntVal(v-1)})
        | FloatVal(v) ->
            Some(env, {node with Expr = FloatVal(v-1.0f)})
        | _ ->
            match (reduce env arg) with
            | Some(env', arg2) ->
                Some(env', {node with Expr = CSDcr(arg2)})
            | None -> None
    | AddAsg(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with 
        | (IntVal(v1), IntVal(v2)) -> 
            Some(env, {node with Expr = IntVal(v1+v2)})
        | (FloatVal(v1), FloatVal(v2)) -> 
            Some(env, {node with Expr = FloatVal(v1+v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with 
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = AddAsg(lhs', rhs')})
            | None -> None
    | MinAsg(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with 
        | (IntVal(v1), IntVal(v2)) -> 
            Some(env, {node with Expr = IntVal(v1-v2)})
        | (FloatVal(v1), FloatVal(v2)) -> 
            Some(env, {node with Expr = FloatVal(v1-v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with 
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = MinAsg(lhs', rhs')})
            | None -> None
    
    | Eq(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 = v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 = v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Eq(lhs', rhs')})
            | None -> None

    | Less(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 < v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 < v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Less(lhs', rhs')})
            | None -> None
    
    | LessOrEq(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 <= v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 <= v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = LessOrEq(lhs', rhs')})
            | None -> None
    
    | Greater(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 > v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 > v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = Greater(lhs', rhs')})
            | None -> None

    | GreaterOrEq(lhs, rhs) ->
        match (lhs.Expr, rhs.Expr) with
        | (IntVal(v1), IntVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 >= v2)})
        | (FloatVal(v1), FloatVal(v2)) ->
            Some(env, {node with Expr = BoolVal(v1 >= v2)})
        | (_, _) ->
            match (reduceLhsRhs env lhs rhs) with
            | Some(env', lhs', rhs') ->
                Some(env', {node with Expr = GreaterOrEq(lhs', rhs')})
            | None -> None
    | ReadInt ->
        match env.Reader with
        | None -> None
        | Some(reader) ->
            /// Input read from the runtime environment
            let input = reader()
            // Use the invariant culture to parse the integer value
            match System.Int32.TryParse(input, System.Globalization.NumberStyles.AllowLeadingSign,
                                        System.Globalization.CultureInfo.InvariantCulture) with
            | (true, result) ->
                Some(env, {node with Expr = IntVal(result)})
            | (false, _) ->
                Some(env, {node with Expr = UnitVal})

    | ReadFloat ->
        match env.Reader with
        | None -> None
        | Some(reader) ->
            /// Input read from the console
            let input = reader()
            /// Format used to parse the input
            let format = System.Globalization.NumberStyles.AllowLeadingSign
                         ||| System.Globalization.NumberStyles.AllowDecimalPoint
            // Use the invariant culture to parse the floating point value
            match System.Single.TryParse(input, format,
                                         System.Globalization.CultureInfo.InvariantCulture) with
            | (true, result) ->
                Some(env, {node with Expr = FloatVal(result)})
            | (false, _) ->
                Some(env, {node with Expr = UnitVal})

    | Print(arg) ->
        match env.Printer with
        | None -> None
        | Some(printer) -> // Reductum when printing succeeds (a unit value)
            let reductum = Some(env, {node with Expr = UnitVal})
            match arg.Expr with
            | BoolVal(v) -> printer $"%A{v}"; reductum
            | IntVal(v) -> printer $"%d{v}"; reductum
            | FloatVal(v) -> printer $"%f{v}"; reductum
            | StringVal(v) -> printer $"%s{v}"; reductum
            | _ when not (isValue node) ->
                match (reduce env arg) with
                | Some(env', arg2) ->
                    Some(env', {node with Expr = Print(arg2)})
                | None -> None
            | _ -> None

    | PrintLn(arg) ->
        // We recycle the evaluation of 'Print', by rewriting this AST node
        match (reduce env {node with Expr = Print(arg)}) with
        | Some(env', n) ->
            match n.Expr with
            | Print(targ) ->
                // Patch the reduced AST to restore the 'PrintLn' node
                Some(env', {n with Expr = PrintLn(targ)})
            | UnitVal ->
                // The 'Print' has been fully evaluated, let'd add newline
                match env.Printer with
                | None -> None
                | Some(printer) ->
                    printer $"%s{Util.nl}"
                    Some(env', n)
            | _ -> failwith $"BUG: unexpected 'Print' reduction ${n}"
        | None -> None
    
    | Sqrt(arg) ->
        match arg.Expr with
        | FloatVal(v) -> Some(env, {node with Expr = FloatVal(sqrt v)})
        | _ ->
            match (reduce env arg) with
            | Some(env', arg') ->
                Some(env', {node with Expr = Sqrt(arg')})
            | None -> None

    | If(cond, ifTrue, ifFalse) ->
        match cond.Expr with
        | BoolVal(v) ->
            let branch = if v then ifTrue else ifFalse
            Some(env, {node with Expr = branch.Expr})
        | _ ->
            match (reduce env cond) with
            | Some(env', cond') ->
                Some(env', {node with Expr = If(cond', ifTrue, ifFalse)})
            | None -> None

    | Seq(nodes) ->
        match nodes with
        | [] -> Some(env, {node with Expr = UnitVal})
        | [last] -> // Last node in Seq: if it's a value, we reduce to it
            if isValue last then
                Some(env, {node with Expr = last.Expr})
            else
                match (reduce env last) with
                | Some(env', last') ->
                    Some(env', {node with Expr = last'.Expr})
                | None -> None
        | first :: rest -> // Notice that here 'rest' is non-empty
            if not (isValue first) then
                match (reduce env first) with
                | Some(env', first') ->
                    Some(env', {node with Expr = Seq(first' :: rest)})
                | None -> None
            else
                Some(env, {node with Expr = Seq(rest)})

    | Ascription(_, arg) -> Some(env, {node with Expr = arg.Expr})

    | Assertion(arg) ->
        match arg.Expr with
        | BoolVal(true) -> Some(env, {node with Expr = UnitVal})
        | _ ->
            match (reduce env arg) with
            | Some(env', arg') ->
                Some(env', {node with Expr = Assertion(arg')})
            | None -> None

    | Let(name, tpe, init, scope, _) ->
        match (reduce env init) with
        | Some(env', def') ->
            Some(env', {node with Expr = Let(name, tpe, def', scope, false)})
        | None when (isValue init) ->
            Some(env, {node with Expr = (ASTUtil.subst scope name init).Expr})
        | None -> None

    | LetRec(name, tpe, init, scope, _) ->
            match init.Expr with
            | Lambda(_) -> 
                let s = {scope with Expr = Var(name)}
                let v' = ASTUtil.subst init name {node with Expr = LetRec(name, tpe, init, s, false)}
                Some(env, ASTUtil.subst scope name v')
            | _ -> None

    | LetMut(_, _, _, scope, _) when (isValue scope) ->
        Some(env, {node with Expr = scope.Expr})
    | LetMut(name, tpe, init, scope, _) ->
        match (reduce env init) with
        | Some(env', def') ->
            Some(env', {node with Expr = LetMut(name, tpe, def', scope, false)})
        | None when (isValue init) ->
            /// Runtime environment for reducing the 'let mutable...' scope
            let env' = {env with Mutables = env.Mutables.Add(name, init)}
            match (reduce env' scope) with
            | Some(env'', scope') ->
                /// Updated init value for the mutable variable
                let init' = env''.Mutables[name] // Crash if 'name' not found
                /// Updated runtime environment.  If the declared mutable
                /// variable 'name' was defined in the outer scope, we restore
                /// its old value (consequently, any update to the redefined
                /// variable 'name' is only visible in its scope).  Otherwise,
                /// we remove it from the updated runtime environment (so it
                /// is only visible in its scope)
                let env''' =
                    match (env.Mutables.TryFind(name)) with
                    | Some(v) -> {env'' with
                                    Mutables = env''.Mutables.Add(name, v)}
                    | None -> {env'' with
                                Mutables = env''.Mutables.Remove(name)}
                Some(env''', {node with Expr = LetMut(name, tpe, init', scope', false)})
            | None -> None
        | None -> None

    | Assign({Expr = FieldSelect(selTarget, field)} as target,
             expr) when not (isValue selTarget)->
        match (reduce env selTarget) with
        | Some(env', selTarget') ->
            let target' = {target with Expr = FieldSelect(selTarget', field)}
            Some(env', {node with Expr = Assign(target', expr)})
        | None -> None
    | Assign({Expr = FieldSelect(_, _)} as target, expr) when not (isValue expr) ->
        match (reduce env expr) with
        | Some(env', expr') ->
            Some(env', {node with Expr = Assign(target, expr')})
        | None -> None
    | Assign({Expr = FieldSelect({Expr = Pointer(addr)}, field)}, value) ->
        match (env.PtrInfo.TryFind addr) with
        | Some(fields) ->
            match (List.tryFindIndex (fun f -> f = field) fields) with
            | Some(offset) ->
                /// Updated env with selected struct field overwritten by 'value'
                let env' = {env with Heap = env.Heap.Add(addr+(uint offset), value)}
                Some(env', value)
            | None -> None
        | None -> None
        
    | Assign({Expr = ArrayElement(selTarget, index)} as target,
             expr) when not (isValue selTarget)->
        match (reduce env selTarget) with
        | Some(env', selTarget') ->
            let target' = {target with Expr = ArrayElement(selTarget', index)}
            Some(env', {node with Expr = Assign(target', expr)})
        | None -> None
    | Assign({Expr = ArrayElement(_, _)} as target, expr) when not (isValue expr) ->
        match (reduce env expr) with
        | Some(env', expr') ->
            Some(env', {node with Expr = Assign(target, expr')})
        | None -> None
    | Assign({Expr = ArrayElement({Expr = Pointer(addr)}, index)}, value) when not (isValue index) ->
        match (reduce env index) with
        | Some(env', index') ->
            let target' = {node with Expr = ArrayElement({node with Expr = Pointer(addr)}, index')}
            Some(env', {node with Expr = Assign(target', value)})
        | None -> None
    | Assign({Expr = ArrayElement({Expr = Pointer(addr)}, index)}, value) -> 
        match (env.PtrInfo.TryFind addr) with
        | Some(elements) ->

            let getLen = // Get length of array
                match (List.tryFindIndex (fun f -> f = "length") elements) with
                | Some(offset) ->
                    match env.Heap[addr + (uint offset)].Expr with
                    | IntVal(i) -> i
                    | _ -> 0
                | None -> 0

            let dataPointer = // Get length of array
                match (List.tryFindIndex (fun f -> f = "data") elements) with
                | Some(offset) ->
                    match env.Heap[addr + (uint offset)].Expr with
                    | Pointer(addr) -> Some(addr)
                    | _ -> None
                | None -> None

            match index.Expr with
            | IntVal(i) ->
                match dataPointer with
                | Some(dataPointer') ->
                    if i < 0 || i >= getLen then // write of out of bounds
                        Log.debug $"Array index %i{i} out of bounds in array of length %i{getLen}"
                        None // Out of bounds
                    else
                        /// Updated env with selected array element overwritten by 'value'
                        let env' = {env with Heap = env.Heap.Add(dataPointer' + (uint i), value)}
                        Some(env', value)
                | None -> None
            | _ -> None
        | None -> None

    | Assign(target, expr) when not (isValue expr) ->
        match (reduce env expr) with
        | Some(env', expr') ->
            Some(env', {node with Expr = Assign(target, expr')})
        | None -> None
    | Assign({Expr = Var(vname)} as target, expr) when (isValue expr)  ->
        match (env.Mutables.TryFind vname) with
        | Some(_) ->
            let env' = {env with Mutables = env.Mutables.Add(vname, expr)}
            Some(env', {node with Expr = expr.Expr})
        | None -> None
    | Assign(_, _) ->
        None

    | While(cond, body) ->
        /// Rewritten 'while' loop, transformed into an 'if' on the condition
        /// 'cond'.  If 'cond' is true, we continue with the whole 'body' of the
        /// loop, followed by the whole loop itself (i.e. the node we have just
        /// matched); otherwise, when 'cond' is false, we do nothing (unit).
        let rewritten = If(cond,
                           {body with Expr = Seq([body; node])},
                           {body with Expr = UnitVal})
        Some(env, {node with Expr = rewritten})

    | DoWhile(body, cond) ->
        let while_node = {node with Expr = While(cond, body)}
        Some(env, {node with Expr = Seq([body; while_node])})

    | For(init, cond, update, body) ->
        let while_body = {node with Expr = Seq([body; update])}
        let while_node = {node with Expr = While(cond, while_body)} 
        Some(env, {node with Expr = Seq([init; while_node])})

    | Type(_, _, scope) ->
        // The interpreter does not use type information at all.
        Some(env, {node with Expr = scope.Expr})

    | Application(expr, args) ->
        match expr.Expr with
        | Lambda(lamArgs, body) ->
            if args.Length <> lamArgs.Length then None
            else
                match (reduceList env args) with
                | Some(env', args') ->
                    Some(env', {node with Expr = Application(expr, args')})
                | None ->
                    // To reduce, make sure all the arguments are values
                    if (List.forall isValue args) then
                        /// Names of lambda term arguments
                        let (lamArgNames, _) = List.unzip lamArgs
                        /// Pairs of lambda term argument names with a
                        /// corresponding value (from 'args') that we are going
                        /// to substitute
                        let lamArgNamesValues = List.zip lamArgNames args
                        /// Folder function to apply a substitution over an
                        /// 'acc'umulator term.  This is used in 'body2' below
                        let folder acc (var, sub) = (ASTUtil.subst acc var sub)
                        /// Lambda term body with all substitutions applied
                        let body2 = List.fold folder body lamArgNamesValues
                        Some(env, {node with Expr = body2.Expr})
                    else None
        | _ ->
            match (reduce env expr) with
            | Some(env', expr') -> Some(env', {node with Expr = Application(expr', args)})
            | None -> None

    | Struct(fields) ->
        let (fieldNames, fieldNodes) = List.unzip fields
        match (reduceList env fieldNodes) with
            | Some(env', fieldNodes') ->
                let fields' = List.zip fieldNames fieldNodes'
                Some(env', {node with Expr = Struct(fields')})
            | None ->
                // If all struct entries are values, place them on the heap in
                // consecutive addresses
                if (List.forall isValue fieldNodes) then
                    /// Updated heap with newly-allocated struct, placed at
                    /// 'baseAddr'
                    let (heap', baseAddr) = heapAlloc env.Heap fieldNodes
                    /// Updated pointer info, mapping 'baseAddr' to the list of
                    /// struct field names
                    let ptrInfo' = env.PtrInfo.Add(baseAddr, fieldNames)
                    Some({env with Heap = heap'; PtrInfo = ptrInfo'},
                         {node with Expr = Pointer(baseAddr)})
                else None

    | FieldSelect({Expr = Pointer(addr)}, field) ->
        match (env.PtrInfo.TryFind addr) with
        | Some(fields) ->
            match (List.tryFindIndex (fun f -> f = field) fields) with
            | Some(offset) ->
                Some(env, env.Heap[addr + (uint offset)])
            | None -> None
        | None -> None
    | FieldSelect(target, field) when not (isValue target)->
        match (reduce env target) with
        | Some(env', target') ->
            Some(env', {node with Expr = FieldSelect(target', field)})
        | None -> None
    | FieldSelect(_, _) -> None

    | UnionCons(label, expr) ->
        match (reduce env expr) with
        | Some(env', expr') -> Some(env', {node with Expr = UnionCons(label, expr')})
        | None when isValue expr ->
            /// Updated heap and base address, with union instance label
            /// followed by 'expr' (which is a value)
            let (heap', baseAddr) =
                heapAlloc env.Heap [{node with Expr = StringVal(label)}; expr]
            Some({env with Heap = heap'}, {node with Expr = Pointer(baseAddr)})
        | None -> None

    | Match(expr, cases) ->
        match (reduce env expr) with
        | Some(env', expr') ->
            Some(env', {node with Expr = Match(expr', cases)})
        | None when isValue expr ->
            match expr.Expr with
            | Pointer(addr) ->
                // Retrieve the label of the union instance from the heap
                match (env.Heap.TryFind addr) with
                | Some({Expr = StringVal(label)}) ->
                    // Retrieve the value of the union instance from the heap
                    match (env.Heap.TryFind (addr + 1u)) with
                    | Some(v) ->
                        // Find match case with label equal to union instance
                        match List.tryFind (fun (l,_,_) -> l = label) cases with
                        | Some(_, var, cont) ->
                            /// Continuation expression where the matched
                            /// variable is substituted by the value of the
                            /// matched union instance
                            let contSubst = ASTUtil.subst cont var v
                            Some(env, {node with Expr = contSubst.Expr})
                        | None -> None
                    | None -> None
                | _ -> None
            | _ -> None
        | None -> None

    | Array(length, data) when (isValue length) && (isValue data) ->
        match length.Expr with
        | IntVal(length') ->

            if length' < 1 then None // array length must be at least size 1
            else

            // allocate space for the array and fill it with the data
            let (heap', baseAddr) = heapAlloc env.Heap (List.replicate length' data)
            // allocate space for the struct and fill it with the length and the pointer to the array
            let pointerStruct = Struct(["data", {node with Expr = Pointer(baseAddr)}; "length", length])
            // return the new heap and the pointer to the struct
            Some({env with Heap = heap'}, {node with Expr = pointerStruct})
        | _ -> None

    | Array(length, data) when (isValue length) ->
        match (reduce env data) with
        | Some(env', data') ->
            Some(env', {node with Expr = Array(length, data')})
        | None -> None

    | Array(length, data) ->    
        match (reduce env length) with
        | Some(env', length') ->
            Some(env', {node with Expr = Array(length', data)})
        | None -> None
    
    | ArrayElement({Expr = Pointer(addr)}, index) when (isValue index) ->
        match (env.PtrInfo.TryFind addr) with
        | Some(elements) ->

            let getLen = // Get length of array
                match (List.tryFindIndex (fun f -> f = "length") elements) with
                | Some(offset) ->
                    match env.Heap[addr + (uint offset)].Expr with
                    | IntVal(i) -> i
                    | _ -> 0
                | None -> 0

            match (List.tryFindIndex (fun f -> f = "data") elements) with
            | Some(offset) ->
                let dataPointer = env.Heap[addr + (uint offset)]
                match dataPointer.Expr with
                | Pointer(dataPointer') ->
                    match index.Expr with
                    | IntVal(index') ->
                        if index' < 0 || index' >= getLen then // read of out of bounds
                            Log.debug $"Array index %i{index'} out of bounds in array of length %i{getLen}"
                            None // Out of bounds
                        else
                            Some(env, env.Heap[dataPointer' + (uint offset) + (uint index')])
                    | _ -> None
                | _ -> None
            | None -> None
        | None -> None
    | ArrayElement(target, index) when not (isValue target)-> 
        match (reduce env target) with
        | Some(env', target') ->
            Some(env', {node with Expr = ArrayElement(target', index)})
        | None -> None
    | ArrayElement(target, index) when not (isValue index)  -> 
        match (reduce env index) with
        | Some(env', index') ->
            Some(env', {node with Expr = ArrayElement(target, index')})
        | None -> None
    | ArrayElement(_, _) -> None

    | ArrayLength({Expr = Pointer(addr)}) ->
        match (env.PtrInfo.TryFind addr) with
        | Some(elements) ->
            match (List.tryFindIndex (fun f -> f = "length") elements) with
            | Some(offset) ->
                Some(env, env.Heap[addr + (uint offset)])
            | None -> None
        | None -> None
    
    | ArrayLength(target) when not (isValue target) -> 
        match (reduce env target) with
        | Some(env', target') ->
            Some(env', {node with Expr = ArrayLength(target')})
        | None -> None
    | ArrayLength(_) -> None

    // ArraySlice
    | ArraySlice({Expr = Pointer(addr)}, start, ending) when ((isValue start) && (isValue ending)) ->
        match start.Expr, ending.Expr with
        | IntVal(start'), IntVal(end') ->
            let length = end' - start'
            if length < 1 then None // array length must be at least size 1
            else
            
            match (env.PtrInfo.TryFind addr) with
            | Some(elements) -> // Get length of array

                    let getLen = // Get length of array
                        match (List.tryFindIndex (fun f -> f = "length") elements) with
                        | Some(offset) ->
                            match env.Heap[addr + (uint offset)].Expr with
                            | IntVal(i) -> i
                            | _ -> 0
                        | None -> 0

                    if start' < 0 || start' >= getLen then // read of out of bounds
                        Log.debug $"Array start index %i{start'} out of bounds in array of length %i{getLen}"
                        None // Out of bounds
                    else if end' < 0 || end' > getLen then // read of out of bounds
                        Log.debug $"Array end index %i{end'} out of bounds in array of length %i{getLen}"
                        None // Out of bounds
                    else

                    match (List.tryFindIndex (fun f -> f = "data") elements) with
                    | Some(offset) ->
                        match env.Heap[addr + (uint offset)].Expr with
                        | Pointer(addr') -> 
                            // apply offset to pointer
                            let baseAddr = addr' + (uint start')
                            // allocate space for the struct and fill it with the length and the updated pointer to the sliced array
                            let pointerStruct = Struct(["data", {node with Expr = Pointer(baseAddr)}; "length", {node with Expr = IntVal(length)}])
                            // return the new heap and the pointer to the struct
                            Some(env, {node with Expr = pointerStruct})
                        | _ -> None
                    | None -> None

            | None -> None
        | _ -> None
    
    | ArraySlice(target, start, ending) when not (isValue target)-> 
        match (reduce env target) with
        | Some(env', target') ->
            Some(env', {node with Expr = ArraySlice(target', start, ending)})
        | None -> None
    | ArraySlice(target, start, ending) when not (isValue start)  -> 
        match (reduce env start) with
        | Some(env', start') ->
            Some(env', {node with Expr = ArraySlice(target, start', ending)})
        | None -> None
    | ArraySlice(target, start, ending) when not (isValue ending)  -> 
        match (reduce env ending) with
        | Some(env', ending') ->
            Some(env', {node with Expr = ArraySlice(target, start, ending')})
        | None -> None
    | ArraySlice(_, _, _) -> None

/// Attempt to reduce the given lhs, and then (if the lhs is a value) the rhs,
/// using the given runtime environment.  Return None if either (a) the lhs
/// cannot reduce although it is not a value, or (b) the lhs is a value but the
/// rhs cannot reduce.
and internal reduceLhsRhs (env: RuntimeEnv<'E,'T>)
                          (lhs: Node<'E,'T>)
                          (rhs: Node<'E,'T>) : Option<RuntimeEnv<'E,'T> * Node<'E,'T> * Node<'E,'T>> =
    if not (isValue lhs) then
        match (reduce env lhs) with
        | Some(env', lhs') -> Some(env', lhs', rhs)
        | None -> None
    else match (reduce env rhs) with
         | Some(env', rhs') -> Some(env', lhs, rhs')
         | None -> None

/// Attempt to reduce the given list of nodes, using the given runtime
/// environment.  Proceed one node a time, following the order in the list; if a
/// node is already a value, attempt to reduce the next one.  If a reduction is
/// possible, return the updated list and environment.  Return None if (a) we
/// reach a node in the list that is stuck, or (b) the list is empty.
and internal reduceList (env: RuntimeEnv<'E,'T>)
                        (nodes: List<Node<'E,'T>>): Option<RuntimeEnv<'E,'T> * List<Node<'E,'T>>> =
    match nodes with
    | [] -> None
    | node :: rest ->
        if not (isValue node) then
            match (reduce env node) with
            | Some(env', n') -> Some(env', n' :: rest)
            | None -> None
        else
            match (reduceList env rest) with
            | Some(env', rest') -> Some(env', node :: rest')
            | None -> None

/// Allocate the given list of AST nodes (which are expected to be values) on
/// the given heap, returning the updated heap and the address where the first
/// given value is allocated.
and internal heapAlloc (heap: Heap<'E,'T>)
                       (values: List<Node<'E,'T>>): Heap<'E,'T> * uint =
    assert(values.Length <> 0) // Sanity check
    assert(List.forall isValue values) // Sanity check
    /// Compute the base address where the given values will be allocated
    let addrs = Set(heap.Keys)
    /// Maximum address already allocated on the heap
    let maxAddr: uint = if addrs.IsEmpty then 0u else addrs.MaximumElement
    /// Base address for the newly-allocated list of values
    let baseAddr = maxAddr + 1u
    /// Fold over the struct field values, adding them to the heap
    let folder (h: Heap<'E,'T>) (offset, n): Heap<'E,'T> =
        h.Add(baseAddr + uint(offset), n)
    let heap2 = List.fold folder heap (List.indexed values)
    (heap2, baseAddr)


/// Reduce the given AST until it cannot reduce further, using the given
/// (optional) 'reader' and 'writer' functions.  Return the final unreducible
/// AST node.
let rec reduceFully (node: Node<'E,'T>)
                    (reader: Option<unit -> string>)
                    (printer: Option<string -> unit>): Node<'E,'T> =
    let env = {Reader = reader; Printer = printer
               Mutables = Map[]
               Heap = Map[]
               PtrInfo = Map[]}
    reduceFullyWithEnv env node
and internal reduceFullyWithEnv (env: RuntimeEnv<'E,'T>) (node: Node<'E,'T>): Node<'E,'T> =
    match (reduce env node) with
    | Some(env', node') -> reduceFullyWithEnv env' node'
    | None -> node


/// Reduce the given AST by the given number of steps, if possible.  Return the
/// resulting AST node and the number of leftover reduction steps: if greater
/// than 0, it means that the returned AST node cannot be reduced further.
let rec reduceSteps (node: Node<'E,'T>)
                    (reader: Option<unit -> string>) (printer: Option<string -> unit>)
                    (steps: int): Node<'E,'T> * int =
    let env = {Reader = reader; Printer = printer
               Mutables = Map[]
               Heap = Map[]
               PtrInfo = Map[]}
    reduceStepsWithEnv env node steps
and internal reduceStepsWithEnv (env: RuntimeEnv<'E,'T>) (node: Node<'E,'T>)
                                (steps: int): Node<'E,'T> * int =
    match (reduce env node) with
    | Some(env', node') -> reduceStepsWithEnv env' node' (steps-1)
    | None -> (node, steps)


/// Is the given AST node stuck?  I.e. is it unreducible, and not a value?
let isStuck (node: Node<'E,'T>): bool =
    if (isValue node) then false
    else
        let env = {Reader = Some(fun _ -> ""); Printer = Some(fun _ -> ())
                   Mutables = Map[]
                   Heap = Map[]
                   PtrInfo = Map[]}
        match (reduce env node) with
         | Some(_,_) -> false
         | None -> true


/// Main interpreter function.  Reduce the given AST node until it cannot reduce
/// further; if 'verbose' is true, also print each reduction step on the console.
let interpret (node: AST.Node<'E,'T>) (verbose: bool): AST.Node<'E,'T> =
    // Reader function used when interpreting (just a regular ReadLine)
    let reader = fun (_: unit) -> System.Console.ReadLine()
    // Printer function used when interpreting (just a regular printf)
    let printer = fun str -> printf $"%s{str}"
    if not verbose then
        reduceFully node (Some reader) (Some printer)
    else
        // Internal function to verbosely interpret step-by-step.
        let rec reduceVerbosely (env: RuntimeEnv<'E,'T>)
                                (ast: AST.Node<'E,'T>): RuntimeEnv<'E,'T> * AST.Node<'E,'T> =
            Log.debug $"Runtime environment:%s{Util.nl}%O{env}"
            Log.debug $"Term to be reduced:%s{Util.nl}%s{PrettyPrinter.prettyPrint ast}"
            match (reduce env ast) with
            | Some(env', node') -> reduceVerbosely env' node'
            | None -> (env, ast)

        let env = {Reader = Some(reader); Printer = Some(printer)
                   Mutables = Map[]
                   Heap = Map[]
                   PtrInfo = Map[]}
        let (env', node') = reduceVerbosely env node
        node'
