//
//  DictionaryExtraUnit.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 09/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public struct DictionaryExtraUnit {
    
    public private(set) var loValue: BaseType = 0
    public private(set) var hiValue: BaseType = 0
    
    public var isFixed:Bool {
        get {
            return loValue & 1 == 1
        }
        set {
            loValue |= 1
        }
    }
    
    public var isUsed:Bool {
        get {
            return hiValue & 1 == 1
        }
        set {
            hiValue |= 1
        }
    }
    
    public var next:BaseType {
        get {
            return loValue >> 1
        }
        set {
            loValue = (loValue & 1) | (next << 1)
        }
    }
    
    public var prev:BaseType {
        get {
            return hiValue >> 1
        }
        set {
            hiValue = (hiValue & 1) | (prev << 1)
        }
    }
}
