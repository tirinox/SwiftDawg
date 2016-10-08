//
//  BaseUnit.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public struct BaseUnit {
    
    public func base() -> BaseType { return _base; }
    public func child() -> BaseType { return _base >> 2; }
    public func has_subling() -> Bool { return (_base & 1) != 0 ? true : false; }
    public func value() -> ValueType { return (ValueType)(_base >> 1); }
    public func is_state() -> Bool { return (_base & 2) != 0 ? true : false; }
    
    private var _base:BaseType = 0;
}
