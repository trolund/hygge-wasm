/// this module defines the system interface for hygge applications
module hyggec.SI
open WGF.Module

/// all the imports from the host func that is provided by the system
let si : Map<string, Import> =
    Map.ofList [
    ("malloc", ("env", "malloc", FunctionType("malloc", Some([ (None, I32) ], [ I32 ]))))
    ("readInt", ("env", "readInt", FunctionType("readInt", Some(([], [ I32 ])))))
    ("readFloat", ("env", "readFloat", FunctionType("readFloat", Some(([], [ F32 ])))))
    ("writeInt", ("env", "writeInt", FunctionType("writeInt", Some(([ (None, I32) ], [])))))
    ("writeFloat", ("env", "writeFloat", FunctionType("writeFloat", Some(([ (None, F32) ], [])))))
    ("writeS", ("env", "writeS", FunctionType("writeS", Some(([ (None, I32); (None, I32) ], [])))))
    // ("readS", ("env", "readS", FunctionType("readS", Some(([], [ I32 ])))))
    ]

/// provide function to get an import from the system interface 
let getImport key =
        Map.find key si