module hyggec.Config

type MemoryConfig =
    | External
    | Internal
    | Heap

type SI =
    | WASI
    | HyggeSI

type CompileConfig = { AllocationStrategy: MemoryConfig; Si: SI }
