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
    public let root:BaseType = 0
    
    public func hasValue(index:BaseType) -> Bool { return units[Int(index)].hasLeaf }
    public func value(index:BaseType) -> ValueType { return units[Int(index ^ units[Int(index)].offset)].value }

    public init(dictionaryUnits: [DictionaryUnit]) {
        units = dictionaryUnits
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
    
    public func follow(labels:[UCharType], index:BaseType) -> (Bool, BaseType) {
        var currentIndex = index
        var success:Bool
        for label in labels {
            (success, currentIndex) = follow(label: label, index:currentIndex)
            if !success {
                return (false, 0)
            }
        }
        return (true, currentIndex)
    }
    
    public func contains(labels:[UCharType]) -> Bool {
        let (success, index) = follow(labels:labels, index:root)
        return success && hasValue(index: index)
    }
}

enum DawgDictionaryError: Error {
    case NoData
    case FileSizeMismatch
}

extension DawgDictionary {
    
    public convenience init(fileName: String) throws {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: fileName)) else {
            throw DawgDictionaryError.NoData
        }
    
        let size:BaseType = data.getValueAt(position: 0)
        let sizeofBaseType = MemoryLayout<BaseType>.size
        let restofSize = data.count - sizeofBaseType
        let begin = SizeType(sizeofBaseType)
        
        if SizeType(size) * sizeofBaseType != restofSize {
            throw DawgDictionaryError.FileSizeMismatch
        }
        let onlyUnits = data.subdata(in: Range(uncheckedBounds: (lower: begin, upper: data.count)))
        self.init(data: onlyUnits)
    }
    
    // aka load from data
    public convenience init(data: Data) {
        self.init(dictionaryUnits: data.withUnsafeBytes {
            Array(UnsafeBufferPointer<DictionaryUnit>(start: $0, count: data.count / MemoryLayout<BaseType>.size))
        })
    }
    
    // aka save to fata
    public var data:Data {
        return Data(buffer: UnsafeBufferPointer(start: units, count: units.count))
    }
}
