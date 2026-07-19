# Bulk memory: filling array constructors with memory.copy

`array(length, value)` (the linear-memory allocation strategies — `External`
and `Internal`; WasmGC's `Heap` strategy already fills in one native
`array.new` instruction and isn't affected by this) used to fill every
element with its own `i32.store`/`f32.store` in a hand-written Wasm loop —
one store instruction per element, O(n) for an array of length n. The code
even had a `// TODO: optimize loop` sitting next to it.

## Why not memory.fill

Wasm's `memory.fill (dest) (value) (size)` only repeats a single **byte**
across a range — it can't express an arbitrary 4-byte `i32`/`f32` element
value (e.g. filling with `42` would need the byte pattern `2A 00 00 00`
repeated, which isn't what `memory.fill` does; it would repeat `2A 2A 2A 2A`
instead). It only works, as-is, for the specific case of zero-initialization.
Real Hygge programs construct arrays with plenty of non-zero constants
(`array(n, 42)`, `array(n, 1994)`, `array(n, temp)`, ...), so a zero-only
fast path would miss most of what's actually out there in this repo's own
test suite.

## What was done instead: memory.copy with doubling

In [`WasmCodegen.fs`](../src/wasm/WasmCodegen.fs), the `Array(length, data)`
case now:

1. Writes the single `data` element once, at index 0.
2. Repeatedly calls `memory.copy(dest, src, size)` to duplicate the
   already-written prefix onto the immediately following, not-yet-written
   region — doubling the filled portion each time (the last iteration is
   clamped to whatever's left with a `min(copied, length - copied)`, so it
   also handles lengths that aren't a power of two).

This takes O(log n) `memory.copy` calls instead of O(n) individual stores,
works for **any** element value (constant or computed) since it's just
copying bytes that are already correct rather than re-deriving them, and
needs no type-specific handling beyond what already existed (`storeInstr`
still picks `i32.store` vs `f32.store` for the single first-element write).

## IR/printer additions

`MemoryCopy` and `MemoryFill` (the latter added now for parity/future use,
not currently emitted anywhere) were added to the shared Wasm IR
([`WGF/Instructions.fs`](../WGF/Instructions.fs)) and wired into the text
printer ([`WGF/WatGen.fs`](../WGF/WatGen.fs)) by joining the existing generic
"single flat operand list" instruction group that `memory.grow` already used
— no bespoke printing code needed. Also added to the handful of
non-exhaustive helper functions that don't have a wildcard fallback and
would otherwise crash on an unrecognized instruction
(`WasmPeepholeHelper.countFunctionInstrs`), plus the recursive cases in
`WasmPeephole.optimizeInstr` and `WasmCodegen.localSubst` (the latter is what
promotes captured-closure locals to globals — confirmed working via a
generated `.wat` showing `global.get $chunk`/`global.get $copied` after
promotion).

## Verified

- Bulk-memory operations work out of the box on Wasmtime 44 (this repo's
  pinned version) with no `Config` change needed — checked directly against
  a standalone `memory.fill`/`memory.copy` module before touching the
  codegen.
- Full test suite (1407 tests) passes, including the sorting algorithms
  (`quickSort.hyg`, `mergeSort.hyg`, `bubblesort.hyg`, etc.) that construct
  and mutate arrays extensively.
- Manually verified odd, non-power-of-two lengths (7 and 17 elements) with a
  non-zero fill value, checking every element individually, under both the
  `External` and `Internal` allocation strategies — exercises the clamped
  last-chunk path in the doubling loop.

## Known gaps / open items

- `MemoryFill` was added to the IR for parity but isn't used anywhere yet —
  a genuine zero-initialization fast path (skipping even the first
  `memory.copy` round) would still be a marginal win on top of this if
  profiling ever shows it matters.
- No equivalent change was made for WasmGC's `Heap` strategy, since
  `array.new` already fills in a single instruction there — nothing to
  optimize.
