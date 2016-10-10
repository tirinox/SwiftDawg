//
//  BaseUnit.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public struct BaseUnit : HasInit {
    
    public var base:BaseType = 0;
    public var child: BaseType { return base >> 2; }
    public var hasSibling: Bool { return (base & 1) != 0 ? true : false; }
    public var value: ValueType { return (ValueType)(base >> 1); }
    public var isState: Bool { return (base & 2) != 0 ? true : false; }
    
    public static func zero() -> BaseUnit { return BaseUnit() }
}
