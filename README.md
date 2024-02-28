# HyggeWasm - The Hygge to WebAssembly compiler

This is the source code of the `HyggeWasm` compiler. `HyggeWasm` is a WebAssembly compiler for the Hygge programming language. `HyggeWasm` has been developed as part of the master thesis "Design and Implementation of a WebAssembly Compiler Back-End for the High-Level Programming Language Hygge" by Troels Lund at Technical University of Denmark. (DTU).

The `HyggeWasm` compiler is based on `hyggec` and uses the Hygge programming language as the the *source language*. `hyggec` and Hygge programming language was created by Alceste Scalas at DTU. 

<img src="img/logo.svg" width="250">

## Software Requirements

  * .NET 8.0 (for compiling and running `HyggeWasm`)
    - On Ubuntu and Debian GNU/Linux: `apt install dotnet8`
    - On MacOS: `brew install dotnet@8`
    - On Windows: <https://dotnet.microsoft.com/en-us/download>

## Useful tools

* [WABT](https://github.com/WebAssembly/wabt)
* [wasm-tools](https://github.com/bytecodealliance/wasm-tools)
* [WasmTime](https://docs.wasmtime.dev/cli-install.html)

## Examples

The folder *examples/hygge* contain a variety of example Hygge programs. 

Futhermore can programs found in the *tests* be used for inspiration. 

## Quick Start

After installing the required software above, open a terminal in the root
directory of the `HyggeWasm` source tree, and try:

```
./hyggec test
```

This command automatically builds `HyggeWasm` and runs its test suite. If you don't
see any error, then `HyggeWasm` was built correctly and passed all its tests.  You
should now be able to use and modify it.

To see the usage options, you can execute:

```
./hyggec help
```

You will see a list of various commands.  To get usage options for a specific
command (for example, `compile`):

```
./hyggec compile --help
```

Here's something you can try:

```
./hyggec interpret --typecheck --verbose examples/hygge0-spec-example.hyg
```

## Building `HyggeWasm` from the Command Line

Every time you invoke the script `./hyggec`, the compiler will be rebuilt if its
source code was modified since the last execution.

You can also (re)build the `HyggeWasm` executable by running:

```
dotnet build
```

To clean up the results of a build, you can run:

```
dotnet clean
```



## Recommended Visual Studio Code Extensions

These Visual Studio Code extensions are very helpful when working on `HyggeWasm`:

  * [Ionide for F#](https://marketplace.visualstudio.com/items?itemName=Ionide.Ionide-fsharp)
  * [FSharp fsl and fsy](https://marketplace.visualstudio.com/items?itemName=mnxn.fsharp-fsl-fsy)
  * [WebAssembly](https://marketplace.visualstudio.com/items?itemName=dtsvet.vscode-wasm)


# Use of the CLI

## Run test suite
The CLI lets the user run the test suite.

    ./hyggec test

## Compile Hygge program

    ./hyggec <path to hygge program> -s l -o <path to wat output file> -e -i 0 -m 1

| Flag | Description               | Input's                                           |
|------|---------------------------|---------------------------------------------------|
| _    | Input                     | path to hygge program                             |
| -s   | Writring style            | linar ("l") or folded ("f")                       |
| -o   | Output file               | Path to wat output file                           |
| -i   | System interface          | 0 - HyggeSI or 1 - WASI                           |
| -m   | Memory mode               | 0 - External or 1 - Internal or 2 - Heap (WasmGC) |
| -e   | Execute after compilation| _                                                 |

## Run .wat file standalone

The CLI lets the user run the ’.wat’-file with WasmTime and the HyggeWasm runtime.
        
        
    ./hyggec wasm test.wat