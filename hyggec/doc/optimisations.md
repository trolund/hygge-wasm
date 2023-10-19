Common instruction patterns in WebAssembly that can be replaced with more efficient alternatives:

1. **Constant Multiplication by Powers of 2:**
   - Replace `i32.const x` followed by `i32.mul` with `i32.shl x`. This is more efficient for multiplication by powers of 2.

   ```wasm
   ; Before
   i32.const 2
   i32.mul

   ; After
   i32.const 1
   i32.shl
   ```

2. **Constant Division by Powers of 2:**
   - Replace `i32.const x` followed by `i32.div_s` with `i32.shr_s x`. This is more efficient for division by powers of 2.

   ```wasm
   ; Before
   i32.const 2
   i32.div_s

   ; After
   i32.const 1
   i32.shr_s
   ```

3. **Bitwise AND for Modulo by Power of 2:**
   - Replace `i32.const x` followed by `i32.rem_s` with `i32.const (x - 1)` followed by `i32.and`.

   ```wasm
   ; Before
   i32.const 4
   i32.rem_s

   ; After
   i32.const 3
   i32.and
   ```

4. **Conditional Negation:**
   - Replace `if (condition) x = -x` with `x = x ^ (condition - 1)`, where `^` is the bitwise XOR.

   ```wasm
   ; Before
   if (condition)
     i32.const -5
   else
     i32.const 5

   ; After
   i32.const 5
   i32.const 1
   i32.xor
   i32.const 0
   i32.select
   ```

5. **Zero Initialization:**
   - Replace `i32.const 0` followed by `i32.add` with the original value. This is an optimization when adding zero.

   ```wasm
   ; Before
   i32.const 0
   i32.add

   ; After
   i32.const x  ; where x is the original value
   ```

6. **Squaring a Value:**
   - Replace `i32.mul` with `i32.mul` for squaring a value.

   ```wasm
   ; Before
   i32.const x
   i32.mul

   ; After
   i32.const x
   i32.const x
   i32.mul
   ```
