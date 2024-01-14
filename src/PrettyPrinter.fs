// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Alceste Scalas <alcsc@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

/// Functions for pretty-printing compiler data structures (e.g. ASTs).
module PrettyPrinter

open AST


/// Newline symbol for the current operating system.
let internal nl = System.Environment.NewLine


/// Generic hierarchical representation of a tree for pretty-printing.
type internal Tree =
    /// Tree node with a description and a (possibly empty) list of subtrees.
    | Node of descr: string * subtrees: List<string * Tree>

    with
        /// Return a nice, indenter representation of the tree.  The argument
        /// 'indent' is a string (expected to only contain spaces) providing the
        /// visual indentation from the left.
        member this.Format (indent: string): string =
            match this with
            | Node(descr, subtrees) ->
                let rec formatChildren (children: List<string * Tree>) (indent: string): string =
                    match children with
                    | [] -> ""
                    | [(descr, tree)] -> // Last child
                        let nameStr = if descr <> "" then (descr + ": ") else ""
                        let childIndent = indent + " " + (String.replicate (nameStr.Length + 1) " ")
                        indent + "┗╾" + nameStr + (tree.Format childIndent)
                    | (name, tree) :: rest ->
                        let nameStr = if name <> "" then (name + ": ") else ""
                        let childIndent = indent + "┃" + (String.replicate (nameStr.Length + 1) " ")
                        indent + "┣╾" + nameStr + (tree.Format childIndent)
                            + (formatChildren rest indent)
                descr + nl + (formatChildren subtrees indent)

        /// Return a nice, indented representation of the tree.
        override this.ToString(): string =
            this.Format ""


/// Traverse a Hygge Type and return its hierarchical representation.
let rec internal formatType (t: Type.Type): Tree =
    match t with
    | Type.TBool -> Node("bool", [])
    | Type.TInt -> Node("int", [])
    | Type.TFloat -> Node("float", [])
    | Type.TString -> Node("string", [])
    | Type.TUnit -> Node("unit", [])
    | Type.TVar(name) -> Node(name, [])
    | Type.TFun(args, ret) ->
        /// Formatted argument types with their respective positions
        let argChildren =
            List.map (fun (i, t) -> ($"arg %d{i+1}", formatType t))
                     (List.indexed args)
        Node("fun", (argChildren @
                     [("return", formatType ret)]))
    | Type.TStruct(fields) ->
        /// Formatted fields with their respective type
        let fieldsChildren =
            List.map (fun (f, t) -> ($"field %s{f}", formatType t)) fields
        Node("struct", fieldsChildren)
    | Type.TUnion(cases) ->
        /// Formatted case labels with their respective type
        let casesChildren =
            List.map (fun (f, t) -> ($"label %s{f}", formatType t)) cases
        Node("union", casesChildren)
    | Type.TArray(tpe) -> Node("array", [("element", formatType tpe)])


/// Traverse a Hygge typing environment and return its hierarchical
/// representation.
let rec internal formatTypingEnv (env: Typechecker.TypingEnv): List<string * Tree> =
    let formatMap (m: Map<string, Type.Type>): List<string * Tree> =
        List.map (fun (name, tpe) -> (name, formatType tpe)) (Map.toList m)
    let formatSet (s: Set<string>): string =
        if s.IsEmpty then "∅" else Util.formatAsSet s
    let vars = formatMap env.Vars
    let typeVars = formatMap env.TypeVars
    let varsNode = Node((if vars.IsEmpty then "∅" else "Map"), vars)
    let typeVarsNode = Node((if typeVars.IsEmpty then "∅" else "Map"), typeVars)
    let mutablesNode = Node((formatSet env.Mutables), [])
    [("Env.Vars", varsNode); ("Env.TypeVars", typeVarsNode)
     ("Env.Mutables", mutablesNode)]


/// Traverse an Hygge program AST from the given 'node' and return a
/// hierarchical representation of the AST contents.
let rec internal formatASTRec (node: AST.Node<'E,'T>): Tree =
    /// Build a pretty-printer tree with the given description, AST node,
    /// and list of descendent trees with descriptions.
    let mkTree (descr: string) (node: AST.Node<'E,'T>)
               (children: List<string * Tree>): Tree =
        Node($"%s{descr} %s{node.Pos.Format}",
             (formatNodeTypingInfo node) @ children)
    match node.Expr with
    | UnitVal -> mkTree "UnitVal ()" node []
    | IntVal(value) -> mkTree $"IntVal %d{value}" node []
    | BoolVal(value) -> mkTree $"BoolVal %b{value}" node []
    | FloatVal(value) -> mkTree $"FloatVal %f{value}" node []
    | StringVal(value) -> mkTree $"StringVal \"%s{value}\"" node []
    | Var(name) -> mkTree $"Var %s{name}" node []
    | Min(lhs, rhs) ->
         mkTree "Min" node [("lhs", formatASTRec lhs)
                            ("rhs", formatASTRec rhs)]  
    | Max(lhs, rhs) ->
         mkTree "Max" node [("lhs", formatASTRec lhs)
                            ("rhs", formatASTRec rhs)]
    | Mult(lhs, rhs) ->
        mkTree "Mult" node [("lhs", formatASTRec lhs)
                            ("rhs", formatASTRec rhs)]
    | Div(lhs, rhs) ->
        mkTree "Div" node [("lhs", formatASTRec lhs)
                           ("rhs", formatASTRec rhs)]
    | Rem(lhs, rhs) ->
        mkTree "Rem" node [("lhs", formatASTRec lhs)
                           ("rhs", formatASTRec rhs)]
    | Sub(lhs, rhs) ->
        mkTree "Sub" node [("lhs", formatASTRec lhs)
                           ("rhs", formatASTRec rhs)]
    | Add(lhs, rhs) ->
        mkTree "Add" node [("lhs", formatASTRec lhs)
                           ("rhs", formatASTRec rhs)]                       
    | And(lhs, rhs) ->
        mkTree "And" node [("lhs", formatASTRec lhs)
                           ("rhs", formatASTRec rhs)]
    | Or(lhs, rhs) ->
        mkTree "Or" node [("lhs", formatASTRec lhs)
                          ("rhs", formatASTRec rhs)]
    | Xor(lhs, rhs) ->
        mkTree "Xor" node [("lhs", formatASTRec lhs)
                           ("rhs", formatASTRec rhs)]
    | ShortAnd(lhs, rhs) ->
        mkTree "ShortAnd" node [("lhs", formatASTRec lhs)
                                ("rhs", formatASTRec rhs)]
    | ShortOr(lhs, rhs) ->
        mkTree "ShortOr" node [("lhs", formatASTRec lhs)
                               ("rhs", formatASTRec rhs)]
    | Not(arg) ->
        mkTree "Not" node [("arg", formatASTRec arg)]
    | CSIncr(arg) -> 
        mkTree "CsIncr" node [("arg", formatASTRec arg)]
    | CSDcr(arg) -> 
        mkTree "CsDcr" node [("arg", formatASTRec arg)]
    | AddAsg(lhs, rhs) ->
        mkTree "AddAsg" node [("lhs", formatASTRec lhs)
                              ("rhs", formatASTRec rhs)]
    | MinAsg(lhs, rhs) ->
        mkTree "MinAsg" node [("lhs", formatASTRec lhs)
                              ("rhs", formatASTRec rhs)]
    | Eq(lhs, rhs) ->
        mkTree "Eq" node [("lhs", formatASTRec lhs)
                          ("rhs", formatASTRec rhs)]
    | Less(lhs, rhs) ->
        mkTree "Less" node [("lhs", formatASTRec lhs)
                            ("rhs", formatASTRec rhs)]
    | LessOrEq(lhs, rhs) ->
        mkTree "LessOrEq" node [("lhs", formatASTRec lhs);("rhs", formatASTRec rhs)]
    | Greater(lhs, rhs) ->
        mkTree "Greater" node [("lhs", formatASTRec lhs);("rhs", formatASTRec rhs)]
    | GreaterOrEq(lhs, rhs) ->
        mkTree "GreaterOrEq" node [("lhs", formatASTRec lhs);("rhs", formatASTRec rhs)]
    | ReadInt -> mkTree "ReadInt" node []
    | ReadFloat -> mkTree "ReadFloat" node []
    | Sqrt(arg) ->
        mkTree "Sqrt" node [("arg", formatASTRec arg)]
    | Print(arg) ->
        mkTree "Print" node [("arg", formatASTRec arg)]
    | PrintLn(arg) ->
        mkTree "PrintLn" node [("arg", formatASTRec arg)]
    | If(condition, ifTrue, ifFalse) ->
        mkTree "Conditional" node [("condition", formatASTRec condition);
                                   ("ifTrue", formatASTRec ifTrue)
                                   ("ifFalse", formatASTRec ifFalse)]
    | DoWhile(body, cond) ->
        mkTree "DoWhile" node [("body", formatASTRec body)
                               ("condition", formatASTRec cond)]
    | Seq(nodes) ->
        let children = List.map (fun n -> ("", formatASTRec n)) nodes
        mkTree "Seq" node children
    | Ascription(tpe, node) ->
        mkTree $"Ascription" node [("Ascription", formatPretypeNode tpe)
                                   ("node", formatASTRec node)]
    | Let(name, tpe, init, scope, _) ->
        mkTree $"Let %s{name}" node [("Ascription", formatPretypeNode tpe)
                                     ("init", formatASTRec init)
                                     ("scope", formatASTRec scope)]
    | LetMut(name, tpe, init, scope, _) ->
        mkTree $"Let mutable %s{name}" node [("Ascription", formatPretypeNode tpe)
                                             ("init", formatASTRec init)
                                             ("scope", formatASTRec scope)]

    | LetRec(name, tpe, init, scope, _) ->
        mkTree $"Let rec %s{name}" node [("Ascription", formatPretypeNode tpe)
                                         ("init", formatASTRec init)
                                         ("scope", formatASTRec scope)]

    | Assign(target, expr) ->
        mkTree $"Assign" node [("target", formatASTRec target)
                               ("expr", formatASTRec expr)]
    | While(cond, body) ->
        mkTree $"While" node [("cond", formatASTRec cond)
                              ("body", formatASTRec body)]
    | For(init, cond, update, body) ->
        mkTree $"For" node [("init", formatASTRec init)
                            ("cond", formatASTRec cond)
                            ("update", formatASTRec update)
                            ("body", formatASTRec body)]
    | Assertion(arg) ->
        mkTree "Assertion" node [("arg", formatASTRec arg)]
    | Type(name, def, scope) ->
        mkTree $"Type %s{name}" node [("def", formatPretypeNode def)
                                      ("scope", formatASTRec scope)]
    | Lambda(args, body) ->
        /// Formatted arguments with their pretype
        let argChildren =
            List.map (fun (v, t) -> ($"arg %s{v}", formatPretypeNode t)) args
        mkTree "Lambda" node (argChildren @
                              [("body", formatASTRec body)])
    | Application(expr, args) ->
        /// Formatted arguments with their respective positions
        let argChildren =
            List.map (fun (i, n) -> ($"arg %d{i+1}", formatASTRec n))
                     (List.indexed args)
        mkTree "Application" node (("expr", formatASTRec expr) ::
                                   argChildren)
    | Struct(fields) ->
        /// Formatted fields of the structure
        let fieldsChildren =
            List.map (fun (f, n) -> ($"field %s{f}", formatASTRec n)) fields
        mkTree "Struct" node fieldsChildren
    | FieldSelect(target, field) ->
        mkTree $"FieldSelect %s{field}" node [("expr", formatASTRec target)]
    | Pointer(addr) ->
        mkTree $"Pointer 0x%x{addr}" node []
    | UnionCons(label, expr) ->
        mkTree $"UnionCons %s{label}" node [("expr", formatASTRec expr)]
    | Match(expr, cases) ->
        let casesChildren =
            List.map (fun (l, v, cont) -> ($"case %s{l}{{%s{v}}}",
                                           formatASTRec cont)) cases
        mkTree "Match" node (("expr", formatASTRec expr) :: casesChildren)
    | Array(length, data) -> 
                 mkTree $"Array" node [("length", formatASTRec length)
                                       ("data", formatASTRec data)]
    | ArrayElement(arr, index) -> 
            mkTree $"ArrayElement" node [("arr", formatASTRec arr)
                                         ("index", formatASTRec index)]
    | ArrayLength(arr) -> 
            mkTree $"ArrayLength" node [("arr", formatASTRec arr)]
    | ArraySlice(arr, start, ending) -> 
            mkTree $"ArraySlice" node [("arr", formatASTRec arr)
                                       ("start", formatASTRec start)
                                       ("end", formatASTRec ending)]
    | StringLength(str) -> 
            mkTree $"StringLength" node [("str", formatASTRec str)]

/// Return a description of an AST node, and possibly some subtrees (that are
/// added to the overall tree structure).
and internal formatNodeTypingInfo (node: Node<'E,'T>): List<string * Tree> =
    let envChildren =
        match typeof<'E> with
        | t when t = typeof<unit> -> [] // Nothing to show
        | t when t = typeof<Typechecker.TypingEnv> ->
            formatTypingEnv ((node.Env :> obj) :?> Typechecker.TypingEnv)
        | t -> failwith $"BUG: unsupported AST environment type for pretty-printing: %O{t}"
    let typeChildren =
        match typeof<'T> with
        | t when t = typeof<unit> -> [] // Nothing to show
        | t when t = typeof<Type.Type> ->
            [("Type", formatType ((node.Type :> obj) :?> Type.Type))]
        | t -> failwith $"BUG: unsupported AST type argument for pretty-printing: %O{t}"
    envChildren @ typeChildren

/// Format a list of children of an AST node.  Each child is a pair with a
/// descriptive name (which may be empty) and an AST node.
and internal formatChildren<'E,'T> (children: list<string * Node<'E,'T>>): List<string * Tree> =
    List.map (fun (descr, node) -> (descr, formatASTRec node)) children

/// Traverse the Abstract Syntax Tree of a Hygge pretype from the given node,
/// and return a string containing a readable representation of the pretype AST
/// contents. 'indent' is a string (expected to contain only spaces) providing
/// the visual indentation from the left.
and internal formatPretypeNode (node: PretypeNode): Tree =
    match node.Pretype with
    | Pretype.TId(id) ->
        Node((formatPretypeDescr node $"Pretype Id \"%s{id}\""), [])
    | Pretype.TFun(args, ret) ->
        /// Formatted argument pretypes with their respective position
        let argChildren =
            List.map (fun (i, t) -> ((formatPretypeDescr t $"arg %d{i+1}"),
                                     formatPretypeNode t))
                     (List.indexed args)
        Node((formatPretypeDescr node "Function pretype"),
             argChildren @
             [("return", formatPretypeNode ret)])
    | Pretype.TStruct(fields) ->
        /// Formatted pretypes of each field with their respective field name
        let fieldsChildren =
            List.map (fun (name, t) -> ((formatPretypeDescr t $"field %s{name}"),
                                        formatPretypeNode t)) fields
        Node((formatPretypeDescr node "Struct pretype"), fieldsChildren)
    | Pretype.TUnion(cases) ->
        /// Formatted pretypes of each union case with their respective label
        let casesChildren =
            List.map (fun (name, t) -> ((formatPretypeDescr t $"label %s{name}"),
                                        formatPretypeNode t)) cases
        Node((formatPretypeDescr node "Union pretype"), casesChildren)
    | Pretype.TArray(elements) -> 
                Node((formatPretypeDescr node "Array pretype"), [("element type", formatPretypeNode elements)])

/// Format the description of a pretype AST node (without printing its
/// children).
and internal formatPretypeDescr (node: PretypeNode) (descr: string) : string =
    $"%s{descr}; pos: %s{node.Pos.Format}"

 /// Format the an AST node with a list of children.
and internal formatPretypeNodeWithChildren (node: PretypeNode) (descr: string)
                                           (children: list<string * PretypeNode>): Tree =
    Node((formatPretypeDescr node descr), (formatPretypeChildren children))

/// Format a list of children of an AST node.  Each child is a pair with a
/// descriptive name (which may be empty) and an AST node.  'indent' is a string
/// (expected to only contain spaces) providing the visual indentation from the
/// left.
and internal formatPretypeChildren (children: list<string * PretypeNode>): List<string * Tree> =
    List.map (fun (descr, node) -> (descr, formatPretypeNode node)) children


/// Return a compact but readable representation of the AST.
let prettyPrint<'E,'T> (node: Node<'E,'T>): string =
    (formatASTRec node).ToString()
