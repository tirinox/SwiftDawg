//
//  ObjectPool.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public protocol HasInit {
    static func zero() -> Self
}

public class ObjectPool <ObjectType:HasInit>
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
        if(_size == _blockSize * _blocks.count) {
            _blocks.append([ObjectType](repeating: ObjectType.zero(), count: _blockSize))
        }
        let size = _size
        _size += 1
        return size
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
        _size = 0
        _blocks.removeAll()
    }
    
    private var _blocks = [ObjectArray]();
    public private(set) var _size:SizeType = 0
    private var _blockSize:SizeType
}
