        let body =
            [ (LocalGet(Named(structPointerLabel)), "get struct pointer var")
              (I32Load, "load data pointer") ]
            @ data'.GetAccCode()
            // add mask to data 
            @ [ (GlobalGet(Named("_mask")), "get mask")
                (I32And, "apply mask to data") ]
            // calculate length of array in bytes
            @ length'.GetAccCode()
            @ [ (I32Const 4, "byte offset")
                (I32Mul, "multiply length with byte offset") ]
            @ [ (MemoryFill, "fill memory with value") ]