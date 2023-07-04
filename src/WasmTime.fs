// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Alceste Scalas <alcsc@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

/// Utility functions to launch RARS (RISC-V Assembler and Runtime Simulator)
/// from the hyggec compiler.
module WASMTime

open System
open WasmTimeDriver

/// Error code to signal a RARS assembly error
let asmErrCode: int = 15


// Error code to signal a RARS simulation error
let simErrCode: int = 16


/// Explain the meaning of RARS exit codes.
let explainExitCode (exit: int): string =
    match exit with
    | n when n = RISCVCodegen.assertExitCode ->
        "assertion violation in source program"
    | n when n = asmErrCode ->
        "error in assembly code, likely due to a hyggec codegen bug"
    | n when n = simErrCode ->
        "simulation error, maybe due to a hyggec codegen bug"
    | 0 -> "successful termination"
    | _ -> "other failure while launching or running RARS"


/// Launch RARS on the given assembly code.  If 'warnOnAssertFailure' is true,
/// then log a warning if the RARS exit code denotes an assertion failure.
/// Return the RARS exit code: 0 on success, non-zero in case of error.
let launch (asm: string) (warnOnAssertFailure: bool): int =
    try 
        let tmpDir = Util.mkTempDir "hyggec-"
        Log.debug $"Created temporary directory: %s{tmpDir}"
        let asmFile = System.IO.Path.Combine [| tmpDir; "code.asm" |]
        
        try

          System.IO.File.WriteAllText(asmFile, asm)
          Log.debug $"Saved assembly code in: %s{asmFile}"
    
          let vm = WasmVM()
          Console.WriteLine("asm: " + asmFile)
          let res = vm.RunFile(asmFile, "_start")
          0
          
        with e ->
            Log.error $"Error writing file %s{asmFile}: %s{e.Message}"
            1 // Non-zero exit code
    with e ->
        Log.error $"Error creating temporary directory: %s{e.Message}"
        1 // Non-zero exit code