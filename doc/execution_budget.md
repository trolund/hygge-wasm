# Execution budget (fuel or epoch interruption)

Before this, nothing bounded how long a compiled Hygge program could run. A
runaway or infinite loop wasn't just a problem for that one run: every Wasm
call in the process goes through a single shared background thread
(`WasmExecutionThread`, see [function_pointers.md](function_pointers.md) for
unrelated context on the same runtime), so a hung program blocked every other
pending or future `RunFile`/`Run` call in the whole process, not just its own.

## Two mechanisms, pick one per run

Wasmtime offers two unrelated mechanisms for bounding execution, both
reachable from the `Wasmtime` NuGet package (v44, the version this repo
pins). Exactly one governs a given run:

- **Fuel** (`Config.WithFuelConsumption`, `Store.Fuel`) — a deterministic,
  instruction-based budget. Same program + same fuel always traps at the same
  point on any machine, which is valuable for reproducibility (e.g. tests,
  grading). This is the default when neither is specified.
- **Epoch interruption** (`Config.WithEpochInterruption`,
  `Engine.IncrementEpoch`, `Store.SetEpochDeadline`) — a wall-clock-ish
  timeout, driven by a background timer that ticks a shared counter every
  `EpochTickMs` (50ms). Maps onto "kill it after N seconds," which fuel can't
  express directly, but isn't reproducible: the same program can trap at a
  different point depending on machine speed and scheduling.

## Implementation

In [`WasmVM.cs`](../WasmTimeDriver/WasmVM.cs):

- The shared `Engine`'s `Config` has both `.WithFuelConsumption(true)` and
  `.WithEpochInterruption(true)`. Both must be enabled at the engine level
  regardless of which one a given run actually uses — the engine is a
  process-wide singleton (see the class doc comment on why), so its `Config`
  can't vary per run.
- `WasmVM` takes nullable `fuel` and `timeoutMs` constructor parameters
  (both default `null`). They're mutually exclusive: if `fuel` is given, it
  wins even if `timeoutMs` is also given; if only `timeoutMs` is given, that
  governs; if neither is given, fuel with the default budget
  (`100_000_000`, a rough order-of-magnitude guess, not a measured figure —
  see the `ponytail:` comment at the constructor) is used.
- Before invoking the target function, `RunTarget` sets **both**
  `_store.Fuel` and `_store.SetEpochDeadline(...)` regardless — the one that
  isn't the chosen mechanism gets an effectively unlimited value
  (`ulong.MaxValue` for fuel; a constant `UnlimitedTicks` for epoch, chosen
  to avoid the unsigned-overflow risk `SetEpochDeadline(ulong.MaxValue)`
  would carry, since it adds the value to the current epoch rather than
  treating it as absolute) so it can't realistically trip.
- Each trap is caught and distinguished by `TrapException.Type`:
  `TrapCode.OutOfFuel` vs. `TrapCode.Interrupt`, separate from a normal
  program trap (`TrapCode.Unreachable`, from `assert`/array-bounds/etc.).
  All three still return exit code 42, same as any other trap, so no
  caller's pass/fail contract changed — the only difference is which
  debug-mode log message identifies which budget was hit.

## Example

```csharp
var vm1 = new WasmVM(debug: true, fuel: 1_000_000);
vm1.RunWatString(watForAnInfiniteLoop, "t1");
// -> "warn: execution exceeded its 1000000 fuel budget and was interrupted"

var vm2 = new WasmVM(debug: true, timeoutMs: 500);
vm2.RunWatString(watForAnInfiniteLoop, "t2");
// -> "warn: execution exceeded 500ms timeout and was interrupted"

var vm3 = new WasmVM(debug: true, fuel: 1_000_000, timeoutMs: 60_000);
vm3.RunWatString(watForAnInfiniteLoop, "t3");
// fuel wins when both are given:
// -> "warn: execution exceeded its 1000000 fuel budget and was interrupted"
```

All three return exit code 42 in well under a second instead of hanging
forever. A normal, non-runaway program (e.g.
`examples/hygge/rec-simple.hyg`) runs to completion under the default fuel
budget without tripping it.

## CLI

Both are exposed on the `compile --execute`/`-e` and `wasm` verbs via
`--fuel <n>` and `--timeout <ms>` ([CmdLine.fs](../src/CmdLine.fs));
`makeWasmVM` in [Program.fs](../src/Program.fs) just forwards the two
`Option`s straight through to `WasmVM`'s nullable parameters, so the
mutual-exclusion rule lives in exactly one place (the `WasmVM` constructor).
This also fixed a pre-existing gap where the `-e` path built a bare
`WasmVM()`, so `-v`/`--verbose` never reached it and no debug message was
ever visible from the CLI.

```sh
hyggec -v -e --fuel 1000000 myprogram.hyg
# -> "warn: execution exceeded its 1000000 fuel budget and was interrupted"

hyggec -v -e --timeout 60000 myprogram.hyg
# -> governed by the timeout instead; fuel is neutralised for this run
```

## Known gaps / open items

- The default fuel budget (`100_000_000`) is a guess, not tuned against real
  Hygge programs of varying size — it may need adjusting if it turns out too
  generous (slow to catch a hang) or too tight (trips on legitimately heavy
  recursion/loops).
