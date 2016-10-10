//
//  BaseType.swift
//  SwiftDawg
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import Foundation

public typealias CharType = Int8
public typealias UCharType = UInt8
public typealias ValueType = Int32
public typealias BaseType = UInt32
public typealias SizeType = Int

extension UCharType : HasZero {
    public static func zero() -> UCharType { return 0 }
}

extension BaseType : HasZero {
    public static func zero() -> BaseType { return 0 }
}
