//
//  ObjectPool.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public protocol HasZero {
    static func zero() -> Self
}

public class ObjectPool <ObjectType:HasZero>
{
    public typealias ObjectArray = [ObjectType];
    
    public init(blockSize: SizeType) {
        _blockSize = blockSize;
    }
    
    public init() {
        _blockSize = 1 << 10;
    }
    
    @discardableResult
    public func allocate() -> SizeType {
        if(size == _blockSize * _blocks.count) {
            _blocks.append([ObjectType](repeating: ObjectType.zero(), count: _blockSize))
        }
        let oldSize = size
        size += 1
        return oldSize
    }
    
    public subscript(index: SizeType) -> ObjectType {
        get {
            return _blocks[index / _blockSize][index % _blockSize];
        }
        set(newValue) {
            _blocks[index / _blockSize][index % _blockSize] = newValue
        }
    }
    
    public func clear() {
        size = 0
        _blocks.removeAll()
    }
    
    private var _blocks = [ObjectArray]();
    public private(set) var size:SizeType = 0
    private var _blockSize:SizeType
}
