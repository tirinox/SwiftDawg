//
//  DictionaryUnit.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public struct DictionaryUnit: Equatable {
    
    static let offsetMax: BaseType = 1 << 21
    static let isLeafBit: BaseType = 1 << 31
    static let hasLeafBit: BaseType = 1 << 8
    static let extensionBit: BaseType = 1 << 9
    
    public mutating func setHasLeaf() { _base |= DictionaryUnit.hasLeafBit }
    public mutating func set(value:ValueType) { _base = BaseType(value) | DictionaryUnit.hasLeafBit }
    public mutating func set(label:UCharType) { _base = (_base & ~BaseType(0xFF)) | BaseType(label) }
    
    public mutating func set(offset:BaseType) -> Bool {
        if offset >= DictionaryUnit.offsetMax << 8 {
            return false
        }
        
        _base &= DictionaryUnit.isLeafBit | DictionaryUnit.hasLeafBit | 0xFF
        if offset < DictionaryUnit.offsetMax {
            _base |= offset << 10
        } else {
            _base |= offset << 2 | DictionaryUnit.extensionBit
        }
        return true
    }
    
    public var hasLeaf:Bool { return _base & DictionaryUnit.hasLeafBit != 0 ? true : false }
    public var value:ValueType { return ValueType(_base & ~DictionaryUnit.isLeafBit) }
    public var label:BaseType { return (_base & (DictionaryUnit.isLeafBit | 0xFF)) }
    public var offset:BaseType { return (_base >> 10) << ((_base & DictionaryUnit.extensionBit) >> 6) }
    
    public var _base:BaseType = 0
}

public func == (lhs: DictionaryUnit, rhs: DictionaryUnit) -> Bool {
    return lhs._base == rhs._base
}

public func != (lhs: DictionaryUnit, rhs: DictionaryUnit) -> Bool {
    return lhs._base != rhs._base
}

public extension DictionaryUnit {
    func isEqualTo(other: DictionaryUnit) -> Bool {
        return _base == other._base
    }
}
