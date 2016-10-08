//
//  ObjectPool.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public protocol HasInit {
    init();
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
    
    public func allocate() -> SizeType {
        if(_size == _blockSize * _blocks.count) {
            _blocks.append([ObjectType](repeating: ObjectType(), count: _blockSize))
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
    
    private var _blocks = [ObjectArray]();
    public private(set) var _size:SizeType = 0
    private var _blockSize:SizeType
}
