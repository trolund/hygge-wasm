/// this module defines the system interface for hygge applications
module hyggec.SI
open Wat.WFG

let list = [
    ("malloc", ("env", "malloc", FunctionType("malloc", Some([ (None, I32) ], [ I32 ]))))
    ("readInt", ("env", "readInt", FunctionType("readInt", Some(([], [ I32 ])))))
    ("readFloat", ("env", "readFloat", FunctionType("readFloat", Some(([], [ F32 ])))))
    ("writeInt", ("env", "writeInt", FunctionType("writeInt", Some(([ (None, I32) ], [])))))
    ("writeS", ("env", "writeS", FunctionType("writeS", Some(([ (None, I32); (None, I32) ], [])))))
    ]

// all the imports from the WASI API
let si : Map<string, Import> =
    Map.ofList list

/// provide function to get an import from the system interface 
let getImport key =
        Map.find key si