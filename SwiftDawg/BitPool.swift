//
//  BitPool.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 10/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public class BitPool {
    
    public func set(index: SizeType, bit: Bool) {
        let poolIndex = pool(index: index)
        let bf = bitFlag(BaseType(index))
        if bf != 0 {
            _pool[poolIndex] |= bf
        } else {
            _pool[poolIndex] &= ~bf
        }
    }
    
    public func get(index: SizeType) -> Bool {
        let poolIndex = pool(index: index)
        let bf = bitFlag(BaseType(index))
        return (_pool[poolIndex] & bf) != 0
    }
    
    @discardableResult
    public func allocate() -> SizeType {
        let poolIndex = pool(index: _size)
        if poolIndex == _pool._size {
            _pool.allocate()
            _pool[poolIndex] = 0
        }
        let size = _size
        _size += 1
        return size
    }
    
    public func clear() {
        _pool.clear()
        _size = 0
    }
    
    private var _pool = ObjectPool<UCharType>()
    private var _size:SizeType = 0
    
    private func pool(index: SizeType) -> SizeType { return index / 8 }
    private func bitFlag(_ index: BaseType) -> UCharType {
        return UCharType(1 << (index % 8))
    }
    
}
