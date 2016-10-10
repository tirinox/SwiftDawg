//
//  DawgUnit.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 10/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public struct DawgUnit : HasZero {
    
    public mutating func clear() {
        child = 0
        sibling = 0
        label = 0
        isState = false
        hasSibling = false
    }
    
    public var value:ValueType { return ValueType(child) }
    public var base:BaseType {
        if label == 0 {
            return (child << 1) | (hasSibling ? 1 : 0)
        } else {
            return (child << 2) | (isState ? 2 : 0) | (hasSibling ? 1 : 0)
        }
    }
    
    public var child:BaseType = 0
    public var sibling:BaseType = 0
    public var label:BaseType = 0
    public var isState:Bool = false
    public var hasSibling:Bool = false
    
    public static func zero() -> DawgUnit { return DawgUnit() }
}
