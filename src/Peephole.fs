// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Alceste Scalas <alcsc@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

/// Functions to perform peephole optimizations on RISC-V assembly code.
module Peephole

open RISCV


let isPowerOfTwo (x: int): bool =
    // Check if x is a power of 2
    let rec isPowerOfTwoRec (x: int): bool =
        if x = 1 then true
                 else if x % 2 = 0 then isPowerOfTwoRec (x / 2)
                                    else false
    if x > 0 then isPowerOfTwoRec x
              else false

/// Optimize a list of Text segment statements.
let rec internal optimizeText (text: List<TextStmt>): List<TextStmt> =
    match text with
    // If a small-enough constant integer is loaded and then added, perform
    // a direct `addi` operation instead
    | (RV.LI(rd1, value), comment1) ::
      (RV.ADD(rd2, rs1, rs2), comment2) ::
      rest                                 when rd1 = rs2 && (isImm12 value) ->
        (RV.LI(rd1, value), comment1) ::
        (RV.ADDI(rd2, rs1, Imm12(value)), comment2) ::
        optimizeText rest
    // use slli instead of mull when multiplying by a power of 2
    | (RV.LI(rd1, value), comment1) ::
      (RV.MUL(rd2, rs1, rs2), comment2) ::
      rest                                 when rd1 = rs2 && (isPowerOfTwo value) ->
        
        let log2 x = log x / log 2.0
        let shift = Shamt(uint32 (log2 value))

        (RV.LI(rd1, value), comment1) ::
        (RV.SLLI(rd2, rs1, shift), comment2) ::
        optimizeText rest
    | stmt :: rest ->
        // If we are here, we did not find any pattern to optimize: we skip the
        // first assembly statement and try with the rest
        stmt :: (optimizeText rest)

    | [] -> []


/// Optimize the given assembly code.
let optimize (asm: Asm): Asm =
    /// Recursively perform peephole optimization, until the result stops
    /// changing (i.e. there is nothning more we can optimize).
    let rec optimizeRec (text: List<TextStmt>): List<TextStmt> =
        /// Optimized assembly code
        let optText = optimizeText text
        if (optText = text) then text
                            else optimizeRec optText
    asm.SetText (optimizeRec asm.GetText)
