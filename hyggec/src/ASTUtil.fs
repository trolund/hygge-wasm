// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Alceste Scalas <alcsc@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

/// Utility functions to inspect and manipulate the Abstract Syntax Tree of
/// Hygge programs.
module ASTUtil

open AST


/// Given the AST 'node', return a new AST node where every free occurrence of
/// the variable called 'var' is substituted by the AST node 'sub'.
let rec subst (node: Node<'E,'T>) (var: string) (sub: Node<'E,'T>): Node<'E,'T> =
    match node.Expr with
    | UnitVal
    | IntVal(_)
    | BoolVal(_)
    | FloatVal(_)
    | StringVal(_) -> node // The substitution has no effect

    | Pointer(_) -> node // The substitution has no effect

    | Var(vname) when vname = var -> sub // Substitution applied
    | Var(_) -> node // The substitution has no effect

    | Add(lhs, rhs) ->
        {node with Expr = Add((subst lhs var sub), (subst rhs var sub))}
    | Sub(lhs, rhs) ->
        {node with Expr = Sub((subst lhs var sub), (subst rhs var sub))}
    | Mult(lhs, rhs) ->
        {node with Expr = Mult((subst lhs var sub), (subst rhs var sub))}
    | Div(lhs, rhs) ->
        {node with Expr = Div((subst lhs var sub), (subst rhs var sub))}
    | Rem(lhs, rhs) ->
        {node with Expr = Rem((subst lhs var sub), (subst rhs var sub))}
    
    | Max(lhs, rhs) ->
        {node with Expr = Max((subst lhs var sub), (subst rhs var sub))}
    
    | Min(lhs, rhs) ->
        {node with Expr = Min((subst lhs var sub), (subst rhs var sub))}

    | And(lhs, rhs) ->
        {node with Expr = And((subst lhs var sub), (subst rhs var sub))}
    | Or(lhs, rhs) ->
        {node with Expr = Or((subst lhs var sub), (subst rhs var sub))}
    | Xor(lhs, rhs) ->
        {node with Expr = Xor((subst lhs var sub), (subst rhs var sub))}
    | ShortAnd(lhs, rhs) ->
        {node with Expr = ShortAnd((subst lhs var sub), (subst rhs var sub))}
    | ShortOr(lhs, rhs) ->
        {node with Expr = ShortOr((subst lhs var sub), (subst rhs var sub))}
    | Not(arg) ->
        {node with Expr = Not(subst arg var sub)}
    | CSIncr(arg) ->
        {node with Expr = CSIncr(subst arg var sub)}
    | CSDcr(arg) ->
        {node with Expr = CSIncr(subst arg var sub)}
    | AddAsg(lhs, rhs) ->
        {node with Expr = AddAsg((subst lhs var sub), (subst rhs var sub))}
    | MinAsg(lhs, rhs) ->
        {node with Expr = AddAsg((subst lhs var sub), (subst rhs var sub))}        
    | Eq(lhs, rhs) ->
        {node with Expr = Eq((subst lhs var sub), (subst rhs var sub))}
    | Less(lhs, rhs) ->
        {node with Expr = Less((subst lhs var sub), (subst rhs var sub))}
    | LessOrEq(lhs, rhs) ->
        {node with Expr = Less((subst lhs var sub), (subst rhs var sub))}
    | Greater(lhs, rhs ) ->
        {node with Expr = Greater((subst lhs var sub), (subst rhs var sub))}
    | GreaterOrEq(lhs, rhs ) ->
        {node with Expr = GreaterOrEq((subst lhs var sub), (subst rhs var sub))}

    | ReadInt
    | ReadFloat -> node // The substitution has no effect

    | Print(arg) ->
        {node with Expr = Print(subst arg var sub)}
    | PrintLn(arg) ->
        {node with Expr = PrintLn(subst arg var sub)}
    
    | Sqrt(arg) ->
        {node with Expr = Sqrt(subst arg var sub)}

    | If(cond, ifTrue, ifFalse) ->
        {node with Expr = If((subst cond var sub), (subst ifTrue var sub),
                                                   (subst ifFalse var sub))}

    | Seq(nodes) ->
        let substNodes = List.map (fun n -> (subst n var sub)) nodes
        {node with Expr = Seq(substNodes)}

    | Ascription(tpe, node) ->
        {node with Expr = Ascription(tpe, (subst node var sub))}

    | Let(vname, tpe, init, scope, export) when vname = var ->
        // Do not substitute the variable in the "let" scope
        {node with Expr = Let(vname, tpe, (subst init var sub), scope, export)}
    | Let(vname, tpe, init, scope, export) ->
        {node with Expr = Let(vname, tpe, (subst init var sub),
                              (subst scope var sub), export)}

    | LetMut(vname, tpe, init, scope, export) when vname = var ->
        // Do not substitute the variable in the "let mutable" scope
        {node with Expr = LetMut(vname, tpe, (subst init var sub), scope, export)}
    | LetMut(vname, tpe, init, scope, export) ->
        {node with Expr = LetMut(vname, tpe, (subst init var sub),
                                 (subst scope var sub), export)}
    
    | LetRec(vname, _, _, _, _) when vname = var -> node // No substitution
    | LetRec(vname, tpe, init, scope, export) ->
        {node with Expr = LetRec(vname, tpe, (subst init var sub),
                              (subst scope var sub), export)}

    | Assign(target, expr) ->
        {node with Expr = Assign((subst target var sub), (subst expr var sub))}

    | While(cond, body) ->
        let substCond = subst cond var sub
        let substBody = subst body var sub
        {node with Expr = While(substCond, substBody)}

    | DoWhile(body, cond) ->
        {node with Expr = DoWhile((subst body var sub), (subst cond var sub))}

    | For(init, cond, update, body) ->
        let substInit = subst init var sub
        let substCond = subst cond var sub
        let substUpdate = subst update var sub
        let substBody = subst body var sub
        {node with Expr = For(substInit, substCond, substUpdate, substBody)}

    | Assertion(arg) ->
        {node with Expr = Assertion(subst arg var sub)}

    | Type(tname, def, scope) ->
        {node with Expr = Type(tname, def, (subst scope var sub))}

    | Lambda(args, body) ->
        /// Arguments of this lambda term, without their pretypes
        let (argVars, _) = List.unzip args
        if (List.contains var argVars) then node // No substitution
        else {node with Expr = Lambda(args, (subst body var sub))}

    | Application(expr, args) ->
        let substExpr = subst expr var sub
        let substArgs = List.map (fun n -> (subst n var sub)) args
        {node with Expr = Application(substExpr, substArgs)}

    | Struct(fields) ->
        let (fieldNames, initNodes) = List.unzip fields
        let substInitNodes = List.map (fun e -> (subst e var sub)) initNodes
        {node with Expr = Struct(List.zip fieldNames substInitNodes)}

    | FieldSelect(target, field) ->
        {node with Expr = FieldSelect((subst target var sub), field)}

    | Array(length, data) -> 
        {node with Expr = Array((subst length var sub), (subst data var sub))} 
    | ArrayElement(arr, index) -> 
        {node with Expr = ArrayElement((subst arr var sub), (subst index var sub))}
    | ArrayLength(arr) -> 
        {node with Expr = ArrayLength((subst arr var sub))}

    | ArraySlice(arr, start, ending) -> 
        {node with Expr = ArraySlice((subst arr var sub), (subst start var sub), (subst ending var sub))}

    | UnionCons(label, expr) ->
        {node with Expr = UnionCons(label, (subst expr var sub))}

    | Match(expr, cases) ->
        /// Mapper function to propagate the substitution along a match case
        let substCase(lab: string, v: string, cont: Node<'E,'T>) =
            if (v = var) then (lab, v, cont) // Variable bound, no substitution
            else (lab, v, (subst cont var sub))
        let cases2 = List.map substCase cases
        {node with Expr = Match((subst expr var sub), cases2)}

/// Compute the set of free variables in the given AST node.
let rec freeVars (node: Node<'E,'T>): Set<string> =
    match node.Expr with
    | UnitVal
    | IntVal(_)
    | BoolVal(_)
    | FloatVal(_)
    | StringVal(_)
    | Pointer(_) -> Set[]
    | Var(name) -> Set[name]
    | Add(lhs, rhs)
    | Sub(lhs, rhs)
    | Div(lhs, rhs)
    | Max(lhs, rhs)
    | Min(lhs, rhs)
    | Mult(lhs, rhs) ->
        Set.union (freeVars lhs) (freeVars rhs)
    | And(lhs, rhs)
    | Or(lhs, rhs) ->
        Set.union (freeVars lhs) (freeVars rhs)
    | Not(arg) -> freeVars arg
    | Eq(lhs, rhs)
    | Less(lhs, rhs) ->
        Set.union (freeVars lhs) (freeVars rhs)
    | ReadInt
    | ReadFloat -> Set[]
    | Print(arg)
    | PrintLn(arg) -> freeVars arg
    | If(condition, ifTrue, ifFalse) ->
        Set.union (freeVars condition)
                  (Set.union (freeVars ifTrue) (freeVars ifFalse))
    | Seq(nodes) -> freeVarsInList nodes
    | Ascription(_, node) -> freeVars node
    | Let(name, _, init, scope, _)
    | LetMut(name, _, init, scope, _) ->
        // All the free variables in the 'let' initialisation, together with all
        // free variables in the scope --- minus the newly-bound variable
        Set.union (freeVars init) (Set.remove name (freeVars scope))
    | Assign(target, expr) ->
        // Union of the free names of the lhs and the rhs of the assignment
        Set.union (freeVars target) (freeVars expr)
    | While(cond, body) -> Set.union (freeVars cond) (freeVars body)
    | For(init, cond, update, body) ->
        Set.union (freeVars init)
                  (Set.union (freeVars cond)
                             (Set.union (freeVars update) (freeVars body)))
    | Assertion(arg) -> freeVars arg
    | Type(_, _, scope) -> freeVars scope
    | Lambda(args, body) ->
        let (argNames, _) = List.unzip args
        // All the free variables in the lambda function body, minus the
        // names of the arguments
        Set.difference (freeVars body) (Set.ofList argNames)
    | Application(expr, args) ->
        let fvArgs = List.map freeVars args
        // Union of free variables in the applied expr, plus all its arguments
        Set.union (freeVars expr) (freeVarsInList args)
    | Struct(fields) ->
        let (_, nodes) = List.unzip fields
        freeVarsInList nodes
    | FieldSelect(expr, _) -> freeVars expr
    | UnionCons(_, expr) -> freeVars expr
    | Match(expr, cases) ->
        /// Compute the free variables in all match cases continuations, minus
        /// the variable bound in the corresponding match case.  This 'folder'
        /// is used to fold over all match cases.
        let folder (acc: Set<string>) (_, var, cont: Node<'E,'T>): Set<string> =
            Set.union acc ((freeVars cont).Remove var)
        /// Free variables in all match continuations
        let fvConts = List.fold folder Set[] cases
        Set.union (freeVars expr) fvConts
     | x -> failwith (sprintf "BUG: unhandled node in ANF conversion: %A" node)

/// Compute the union of the free variables in a list of AST nodes.
and internal freeVarsInList (nodes: List<Node<'E,'T>>): Set<string> =
    /// Compute the free variables of 'node' and add them to the accumulator
    let folder (acc: Set<string>) (node: Node<'E,'T> ) =
        Set.union acc (freeVars node)
    List.fold folder Set[] nodes

/// Compute the set of captured variables in the given AST node.
let rec capturedVars (node: Node<'E,'T>): Set<string> =
    match node.Expr with
    | UnitVal
    | IntVal(_)
    | BoolVal(_)
    | FloatVal(_)
    | StringVal(_)
    | Pointer(_)
    | Lambda(_, _) ->
        // All free variables of a value are considered as captured
        freeVars node
    | Var(_) -> Set[]
    | Add(lhs, rhs)
    | Mult(lhs, rhs) ->
        Set.union (capturedVars lhs) (capturedVars rhs)
    | And(lhs, rhs)
    | Or(lhs, rhs) ->
        Set.union (capturedVars lhs) (capturedVars rhs)
    | Not(arg) -> capturedVars arg
    | Eq(lhs, rhs)
    | Less(lhs, rhs) ->
        Set.union (capturedVars lhs) (capturedVars rhs)
    | ReadInt
    | ReadFloat -> Set[]
    | Print(arg)
    | PrintLn(arg) -> capturedVars arg
    | If(condition, ifTrue, ifFalse) ->
        Set.union (capturedVars condition)
                  (Set.union (capturedVars ifTrue) (capturedVars ifFalse))
    | Seq(nodes) -> capturedVarsInList nodes
    | Ascription(_, node) -> capturedVars node
    | Let(name, _, init, scope, _)
    | LetMut(name, _, init, scope, _) ->
        // All the captured variables in the 'let' initialisation, together with
        // all captured variables in the scope --- minus the newly-bound var
        Set.union (capturedVars init) (Set.remove name (capturedVars scope))
    | Assign(target, expr) ->
        // Union of the captured vars of the lhs and the rhs of the assignment
        Set.union (capturedVars target) (capturedVars expr)
    | While(cond, body) -> Set.union (capturedVars cond) (capturedVars body)
    | Assertion(arg) -> capturedVars arg
    | Type(_, _, scope) -> capturedVars scope
    | Application(expr, args) ->
        let fvArgs = List.map capturedVars args
        // Union of captured variables in the applied expr, plus all arguments
        Set.union (capturedVars expr) (capturedVarsInList args)
    | Struct(fields) ->
        let (_, nodes) = List.unzip fields
        capturedVarsInList nodes
    | FieldSelect(expr, _) -> capturedVars expr
    | UnionCons(_, expr) -> capturedVars expr
    | Match(expr, cases) ->
        /// Compute the captured variables in all match cases continuations,
        /// minus the variable bound in the corresponding match case.  This
        /// 'folder' is used to fold over all match cases.
        let folder (acc: Set<string>) (_, var, cont: Node<'E,'T>): Set<string> =
            Set.union acc ((capturedVars cont).Remove var)
        /// Captured variables in all match continuations
        let cvConts = List.fold folder Set[] cases
        Set.union (capturedVars expr) cvConts
    | Sub(lhs, rhs) 
    | Div(lhs, rhs) 
    | Rem(lhs, rhs) 
    | Xor(lhs, rhs) 
    | ShortAnd(lhs, rhs) 
    | ShortOr(lhs, rhs) 
    | Min(lhs, rhs) 
    | Max(lhs, rhs) -> 
        Set.union (capturedVars lhs) (capturedVars rhs)
    | Sqrt(arg) -> (capturedVars arg)
    | LetRec(name, tpe, init, scope, _) -> 
        Set.union (capturedVars init) (Set.remove name (capturedVars scope))
    | DoWhile(body, condition) -> 
        Set.union (capturedVars body) (capturedVars condition)
    | For(init, cond, update, body) ->
        Set.union (capturedVars init) (Set.union (capturedVars cond) (Set.union (capturedVars update) (capturedVars body)))
    | Array(length, data) -> 
        Set.union (capturedVars length) (capturedVars data)
    | ArrayElement(target, index) -> 
        Set.union (capturedVars target) (capturedVars index)
    | ArrayLength(target) -> 
        capturedVars target
    | ArraySlice(target, start, ending) -> 
        Set.union (capturedVars target) (Set.union (capturedVars start) (capturedVars ending))

/// Compute the union of the captured variables in a list of AST nodes.
and internal capturedVarsInList (nodes: List<Node<'E,'T>>): Set<string> =
    /// Compute the free variables of 'node' and add them to the accumulator
    let folder (acc: Set<string>) (node: Node<'E,'T> ) =
        Set.union acc (capturedVars node)
    List.fold folder Set[] nodes


/// capture all free variable in expression and a list of var names that
// List.distinctBy fst (Set.toList captured)
// TODO: maybe use the on in ASTUtil!!
let rec freeVariables (node) =
    List.distinctBy fst (Set.toList (freeVariables' node))

and freeVariables' (node: Node<'a,'b>) =
    let diff set1 set2 = // Find the first elements that are unique to set1
        let firstElements set = set |> Set.map fst

        let differenceSet1 = Set.difference (firstElements set1) (set2)

        // Filter the tuples in set1 based on the first elements found in differenceSet1
        let result = set1 |> Set.filter (fun (x, _) -> Set.contains x differenceSet1)

        result

    match node.Expr with
    | UnitVal -> Set.empty
    | IntVal _ -> Set.empty
    | FloatVal _ -> Set.empty
    | BoolVal _ -> Set.empty
    | StringVal _ -> Set.empty
    | Var v -> Set.singleton (v, node)
    | Seq(exprs) -> List.fold (fun acc (expr) -> Set.union (freeVariables' expr) acc) Set.empty exprs
    | Application(target, args) ->
        List.fold (fun acc (arg) -> Set.union acc (freeVariables' arg)) (freeVariables' target) args
    | Lambda(args, body) ->
        let body' = (freeVariables' body)
        let argsNames = (Set.ofList (List.map fst args))
        let s = diff body' argsNames
        s
    | Match(target, cases) ->
        List.fold
            (fun acc (label, var, expr) -> Set.filter (fun (x, _) -> x <> var) (Set.union (freeVariables' expr) acc))
            (freeVariables' target)
            cases
    | Assign(name, value) -> Set.union (freeVariables' name) (freeVariables' value)
    | FieldSelect(target, _) -> freeVariables' target
    | Ascription(_, node) -> freeVariables' node
    | Let(name, _, bindingExpr, bodyExpr, export) ->
        let set = Set.union (freeVariables' bodyExpr) (freeVariables' bindingExpr)
        // remove name
        Set.filter (fun (x, _) -> x <> name) set
    | LetMut(name, _, init, scope, export) ->
        let set = Set.union (freeVariables' scope) (freeVariables' init)
        // remove name
        Set.filter (fun (x, _) -> x <> name) set
    | LetRec(name, _, lambda, scope, export) ->
        let set = Set.union (freeVariables' scope) (freeVariables' lambda)
        // remove name
        Set.filter (fun (x, _) -> x <> name) set
    | Struct(fields) -> List.fold (fun acc (_, expr) -> Set.union (freeVariables' expr) acc) Set.empty fields
    | ArrayElement(target, index) -> Set.union (freeVariables' target) (freeVariables' index)
    | Mult(lhs, rhs)
    | Div(lhs, rhs)
    | Sub(lhs, rhs)
    | Rem(lhs, rhs)
    | Eq(lhs, rhs)
    | GreaterOrEq(lhs, rhs)
    | Greater(lhs, rhs)
    | LessOrEq(lhs, rhs)
    | Less(lhs, rhs)
    | And(lhs, rhs)
    | Or(lhs, rhs)
    | Max(lhs, rhs)
    | Min(lhs, rhs)
    | Add(lhs, rhs) -> Set.union (freeVariables' lhs) (freeVariables' rhs)
    | AST.If(cond, thenExpr, elseExpr) ->
        Set.union (freeVariables' cond) (Set.union (freeVariables' thenExpr) (freeVariables' elseExpr))
    | While(cond, body) -> Set.union (freeVariables' cond) (freeVariables' body)
    | DoWhile(body, cond) -> Set.union (freeVariables' cond) (freeVariables' body)
    | Not(expr) -> freeVariables' expr
    | For(init, cond, update, body) ->
        Set.union
            (freeVariables' init)
            (Set.union (freeVariables' cond) (Set.union (freeVariables' update) (freeVariables' body)))
    | Assertion(expr) -> freeVariables' expr
    | ArrayLength(target) -> freeVariables' target
    | ArraySlice(target, start, _end) ->
        Set.union (freeVariables' target) (Set.union (freeVariables' start) (freeVariables' _end))
    | UnionCons(_, expr) -> freeVariables' expr
    | Array(length, data) -> Set.union (freeVariables' length) (freeVariables' data)
    | Print(expr) -> freeVariables' expr
    | PrintLn(expr) -> freeVariables' expr
    | ReadInt -> Set.empty
    | _ -> failwithf "freeVariables': unhandled case %A" node