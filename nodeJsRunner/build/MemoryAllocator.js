"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MemoryAllocator = void 0;
class MemoryAllocator {
    constructor(isDebug = false) {
        this.offset = 0;
        this.currentSize = 1;
        this._pageSize = 64 * 1024;
        this._stride = 4;
        this.grow = null;
        this._isDebug = true;
        this._isDebug = isDebug;
    }
    allocate(size) {
        if (this.offset + size > (this.currentSize * this._pageSize) && this.grow) {
            const requiredPages = (this.offset + size) / this._pageSize;
            const roundedPages = Math.ceil(requiredPages) - 1;
            this.grow(roundedPages);
            this.currentSize = requiredPages;
            console.log(`MemoryAllocator: growing memory by ${roundedPages} pages`);
        }
        const addrees = this.offset;
        this.offset += size;
        if (this._isDebug)
            console.log(`MemoryAllocator: allocated ${size} bytes at offset ${addrees}`);
        return addrees;
    }
    setGrow(grow) {
        this.grow = grow;
    }
    get memory() {
        return this._memory;
    }
    set memory(memory) {
        this._memory = memory;
    }
    set(offset) {
        let mul8 = (offset + 7) & (-8);
        this.offset = mul8;
    }
    reset() {
        this.offset = 0;
    }
}
exports.MemoryAllocator = MemoryAllocator;
//# sourceMappingURL=MemoryAllocator.js.map