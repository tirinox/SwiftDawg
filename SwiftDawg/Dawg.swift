//
//  Dawg.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 10/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public class Dawg {
    
    public var root:BaseType { return 0 }
    public var size:SizeType { return _basePool.size }
    
    public func child(index: BaseType) -> BaseType { return _basePool[SizeType(index)].child }
    public func sibling(index: BaseType) -> BaseType { return _basePool[SizeType(index)].hasSibling ? (index + 1) : 0 }
    public func value(index: BaseType) -> ValueType { return _basePool[SizeType(index)].value }
    public func label(index: BaseType) -> UCharType { return _labelPool[SizeType(index)] }
    public func isLeaf(index: BaseType) -> Bool { return label(index: index) == 0 }
    public func isMerging(index: BaseType) -> Bool { return _flagPool.get(index: SizeType(index)) }
    
    public var numOfTransitions:SizeType { return size - 1 }
    
    private var _basePool = ObjectPool<BaseUnit>()
    private var _labelPool = ObjectPool<UCharType>()
    private var _flagPool = BitPool()
    
    public func clear() {
        numOfStates = 0
        numOfMergedStates = 0
        _basePool.clear()
        _flagPool.clear()
        _labelPool.clear()
    }
    
    public var numOfStates = 0
    public var numOfMergedTransitions =  0
    public var numOfMergedStates = 0
    public var numOfMergingStates = 0
    
    public init(basePool: ObjectPool<BaseUnit>, labelPool: ObjectPool<UCharType>, flagPool: BitPool) {
        _basePool = basePool
        _labelPool = labelPool
        _flagPool = flagPool
    }
}
