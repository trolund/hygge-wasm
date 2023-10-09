module Util

open Wat.WFG

    let GenFuncTypeName (t) =
        // generate function type name
        let locals = fst t
        let ret = snd t

        let l = List.fold (fun str x -> str + "_" + x.ToString()) "" locals
        let r = string ret

        $"{l}_=>_{r}"
    