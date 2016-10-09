//
//  SwiftDawgTests.swift
//  SwiftDawgTests
//
//  Created by Максим Кольцов on 08/10/16.
//  Copyright © 2016 Maksim Koltsov. All rights reserved.
//

import XCTest
@testable import SwiftDawg

class SwiftDawgTests: XCTestCase {
    
    var dic:DawgDictionary?
    
    override func setUp() {
        super.setUp()
        
        dic = try? DawgDictionary(fileName: "dic-dawg-en.bin")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoaded() {
        XCTAssert(dic != nil)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
