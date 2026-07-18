# Tail call optimisation

Because every Hygge function call compiles to `call_indirect` (functions are
always called through a closure/table pointer, see
[function_pointers.md](function_pointers.md)), a deeply recursive function
keeps pushing caller frames and can overflow the Wasm call stack, even when
the recursion is written in tail form. This was listed as future work in the
thesis and is now implemented as a peephole pass.

## What it does

A call in **tail position** — the last thing a function does before
returning — is rewritten from `call_indirect` / `call` to
`return_call_indirect` / `return_call`, using the
[Wasm tail-call proposal](https://github.com/WebAssembly/tail-call). These
instructions discard the caller's frame before jumping to the callee, so a
tail-recursive Hygge function runs in constant stack space instead of one
frame per call.

The pass only rewrites an instruction if it is actually in tail position:

- the last instruction of a function body, and, recursively,
- the last instruction of each branch of an `if` that is itself in tail
  position.

Everything else (calls whose result feeds into further computation, calls
inside `assert`, etc.) is left as a normal call.

## Example

```hygge
let rec f: (int, int) -> int = fun(x: int, y: int) -> {
    if ((x + y) < 42) then {
        f(x + 1, y + 1)      // tail position -> return_call_indirect
    }
    else {
        x + y
    }
};
assert(f(0, 0) = 42)          // not tail position -> call_indirect
```

compiles (with optimisations enabled) to:

```wat
(func $fun_f (param $cenv i32) (param $arg_x i32) (param $arg_y i32) (result i32)
  local.get $arg_x
  local.get $arg_y
  i32.add
  i32.const 42
  i32.lt_s
  if (result i32)
    local.get $cenv
    local.get $arg_x
    i32.const 1
    i32.add
    local.get $arg_y
    i32.const 1
    i32.add
    global.get $fun_f*ptr
    i32.load
    return_call_indirect (type $i32_i32_i32_=>_i32)   ;; <- tail call
  else
    local.get $arg_x
    local.get $arg_y
    i32.add
  end
)
```

The call to `f` in the `assert` at the top level is not in tail position
(its result is compared to `42`), so it stays a regular `call_indirect`.

## Enabling it

The pass runs as part of the Wasm peephole optimiser, alongside the other
instruction-level optimisations in [optimisations.md](optimisations.md).
Pass `-O 4` (or any level that enables "all" optimisations) to the compiler:

```sh
hyggec -O 4 -o out.wat myprogram.hyg
```

It applies regardless of memory allocation strategy (`-m 0/1/2`), since it
operates on the generated Wasm instructions rather than the AST.

Wasmtime has tail calls enabled by default since it stabilized the proposal,
so no runtime configuration change is needed to run the resulting module.

## Known limitations

- Only `if`-branches and the function body's own tail position are
  followed. A tail call inside a `loop`/`block` construct (e.g. the blocks
  generated for pattern `match`) is not rewritten, since those exit via
  `br` rather than falling off the end — the "last instruction" rule
  doesn't apply the same way there.
- Only calls, not other tail-position forms, are rewritten; there is
  nothing else in the Wasm backend that would benefit from this pass today.
