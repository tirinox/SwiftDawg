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
    var _numOfStates:SizeType = 0
    var _numOfMergedTransitions:SizeType = 0
    var _numOfMergingStates:SizeType = 0
    
    // warning: check it with a fresh mind
    func fixUnits(index: BaseType) {
        while _unfixedUnits.top! != index {
            let unfixedIndex = _unfixedUnits.pop()
            
            if _numOfStates >= _hashTable.count - (_hashTable.count >> 2) {
                expandHashTable()
            }
            
            var numOfSiblings:BaseType = 0
            var i = unfixedIndex
            while i != 0 {
                numOfSiblings += 1
                i = _unitPool[SizeType(i)].sibling
            }
            
            var (matchedIndex, hashId) = findUnit(unitIndex: unfixedIndex)
            if matchedIndex != 0 {
                _numOfMergedTransitions += SizeType(numOfSiblings)
                
                if _flagPool.get(index: SizeType(matchedIndex)) == false {
                    _numOfMergingStates += 1
                    _flagPool.set(index: SizeType(matchedIndex), bit: true)
                }
            } else {
                var transitionIndex:BaseType = 0
                for _ in 0 ..< numOfSiblings {
                    transitionIndex = allocateTransition()
                }
                i = unfixedIndex
                while i != 0 {
                    let si = SizeType(i)
                    let sti = SizeType(transitionIndex)
                    _basePool[sti].base = _unitPool[si].base
                    _labelPool[sti] = UCharType(_unitPool[si].label)
                    transitionIndex -= 1
                    i = _unitPool[si].sibling
                }
                matchedIndex = transitionIndex + 1
                _hashTable[SizeType(hashId)] = matchedIndex
                _numOfStates += 1
            }
            
            var current = unfixedIndex
            while current != 0 {
                let next = _unitPool[SizeType(current)].sibling
                freeUnit(index: current)
                current = next
            }
            _unitPool[SizeType(_unfixedUnits.top!)].child = matchedIndex
        }
        
        _unfixedUnits.pop()
    }
    
    func expandHashTable() {
        let hashTableSize = _hashTable.count << 1
        _hashTable = [BaseType](repeating: 0, count: hashTableSize)
        
        for i in 1 ..< _basePool.size {
            if _labelPool[i] == 0 || _basePool[i].isState {
                let index = BaseType(i)
                let (_, hashId) = findTransition(index: index)
                _hashTable[SizeType(hashId)] = index
            }
        }
    }
    
    func findTransition(index: BaseType) -> (hashId: BaseType, foundIndex: BaseType) {
        var hashId = hashUnit(index: index) % BaseType(_hashTable.count)
        while true {
            let transitionIndex = _hashTable[SizeType(hashId)]
            if transitionIndex == 0 {
                break
            }
            hashId = (hashId + 1) % BaseType(_hashTable.count)
        }
        
        return (0, hashId)
    }
    
    func findUnit(unitIndex: BaseType) -> (hashId: BaseType, foundIndex: BaseType) {
        let hashId = hashUnit(index: unitIndex) % BaseType(_hashTable.count)
        while true {
            let transitionIndex = _hashTable[SizeType(hashId)]
            if transitionIndex == 0 {
                break
            }
            if areEqual(unitIndex: unitIndex, transitionIndex: transitionIndex) {
                return (transitionIndex, hashId)
            }
        }
        return (0, hashId)
    }
    
    func areEqual(unitIndex: BaseType, transitionIndex: BaseType) -> Bool {
        
        var ti = transitionIndex
        var i = _unitPool[SizeType(unitIndex)].sibling
        while i != 0 {
            
            if _basePool[SizeType(ti)].hasSibling == false {
                return false
            }
            
            i = _unitPool[SizeType(i)].sibling
            ti += 1
        }
        
        if _basePool[SizeType(ti)].hasSibling == true {
            return false
        }
        
        i = unitIndex
        while i != 0 {
            
            if _unitPool[SizeType(i)].base != _basePool[SizeType(ti)].base ||
                UCharType(_unitPool[SizeType(i)].label) != _labelPool[SizeType(ti)] {
                return false
            }
            
            i = _unitPool[SizeType(i)].sibling
            ti -= 1
        }
        
        return true
    }
    
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
