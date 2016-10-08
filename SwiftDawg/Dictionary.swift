//
//  Dictionary.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public class DawgDictionary {
    
    public private(set) var units = [DictionaryUnit]()
    public private(set) var size:SizeType = 0
    public let root:BaseType = 0
    
    public func hasValue(index:BaseType) -> Bool { return units[Int(index)].hasLeaf }
    public func value(index:BaseType) -> ValueType { return units[Int(index ^ units[Int(index)].offset)].value }

    public init(dictionaryUnits: [DictionaryUnit]) {
        units = dictionaryUnits
        size = units.count
    }
    
    public func follow(label:UCharType, index:BaseType) -> (Bool, BaseType) {
        let offset = units[Int(index)].offset
        let nextIndex = index ^ offset ^ BaseType(label)
        let nextLabel = units[Int(nextIndex)].label
        if nextLabel != label {
            return (false, 0)
        } else {
            return (true, nextIndex)
        }
    }
    
    public func follow(labels:[UCharType], index:BaseType) -> Bool {
        var currentIndex = index
        var success:Bool
        for label in labels {
            (success, currentIndex) = follow(label: label, index:currentIndex)
            if !success {
                return false
            }
        }
        return true
    }
    
    public func contains(labels:[UCharType]) -> Bool { return follow(labels:labels, index:root) }
    
    // aka load from data
    public convenience init(data: Data) {
        self.init(dictionaryUnits: data.withUnsafeBytes {
            Array(UnsafeBufferPointer<DictionaryUnit>(start: $0, count: data.count / MemoryLayout<BaseType>.size))
        })
    }
    
    // aka save to fata
    public var data:Data {
        return Data(buffer: UnsafeBufferPointer(start: &units, count: units.count))
    }
}
