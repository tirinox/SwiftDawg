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
}
