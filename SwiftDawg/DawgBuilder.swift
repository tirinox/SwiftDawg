//
//  DawgBuilder.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 10/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

class DawgBuilder {
    
    static let defaultInitialHashTableSize:SizeType = 1 << 8
    let _initialHashTableSize:SizeType
    
    public init(initialHashTableSize: SizeType) {
        _initialHashTableSize = initialHashTableSize
    }
    
    public convenience init() {
        self.init(initialHashTableSize: DawgBuilder.defaultInitialHashTableSize)
    }
    
    var _basePool = ObjectPool<BaseUnit>()
    var _labelPool = ObjectPool<UCharType>()
    var _flagPool = BitPool()
    var _unitPool = ObjectPool<DawgUnit>()
    var _hashTable:[BaseType] = []
    var _unfixedUnits = Stack<BaseType>()
    var _unusedUnits = Stack<BaseType>()
    var _numOfStager:SizeType = 0
    var _numOfMergedTransitions:SizeType = 0
    var _numOfMergingStates:SizeType = 0
    
    func hashTransition(index: BaseType) -> BaseType {
        var hashValue:BaseType = 0
        var i = index
        while i != 0 {
            let base = _basePool[SizeType(i)].base
            let label = _labelPool[SizeType(i)]
            hashValue ^= hash(key: (BaseType(label) << 24) ^ base)
            
            if _basePool[SizeType(i)].hasSibling == false {
                break
            }
            
            i += 1
        }
        return hashValue
    }
    
    func hashUnit(index: BaseType) -> BaseType {
        var hashValue:BaseType = 0
        var i = index
        while i != 0 {
            let unit = _unitPool[SizeType(i)]
            hashValue ^= hash(key: (unit.label << 24) ^ unit.base)
            i = unit.sibling
        }
        return hashValue
    }
    
    // 32-bit mix function.
    // http://www.concentric.net/~Ttwang/tech/inthash.htm
    func hash(key: BaseType) -> BaseType {
        var k = key
        k = ~k + (k << 15)
        k = k ^ (k >> 12)
        k = k + (k << 2)
        k = k ^ (k >> 4)
        k = k * 2057
        k = k ^ (k >> 16)
        return k
    }
    
    func allocateTransition() -> BaseType {
        _flagPool.allocate()
        _basePool.allocate()
        return BaseType(_labelPool.allocate())
    }
    
    func allocateUnit() -> BaseType {
        var index:SizeType
        if(_unusedUnits.empty) {
            index = _unitPool.allocate()
        } else {
            index = SizeType(_unusedUnits.pop())
        }
        _unitPool[index].clear()
        return BaseType(index)
    }
    
    func freeUnit(index: BaseType) {
        _unusedUnits.push(index)
    }
}
