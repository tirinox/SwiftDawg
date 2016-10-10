//
//  Util.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 09/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

extension Data {
    public func getValueAt<T>(position: Int) -> T {
        precondition(position >= 0 && position <= count - MemoryLayout<T>.size)
        
        let value: T = withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            return bytes.advanced(by: position).withMemoryRebound(to: T.self, capacity: 1, { (pointer) -> T in
                return pointer.pointee
            })
        }
    
        return value
    }
    
    public init<T>(withValue: T) {
        var v = withValue
        self.init(buffer: UnsafeBufferPointer(start: &v, count: 1))
    }
}

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

public func englishStringToCharArray(string: String) -> [UCharType] {
    let aCode = Int(Character("a").asciiValue!)
    return string.lowercased().unicodeScalars.filter{$0.isASCII}.map {UCharType(Int($0.value) - aCode + 1)}
}

struct Stack<Element> {
    
    var items = [Element]()
    
    mutating func push(_ item: Element) { items.append(item) }
    mutating func pop() -> Element { return items.removeLast() }
    var empty:Bool { return items.count == 0 }
}

