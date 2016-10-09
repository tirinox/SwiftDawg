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
    
    private func dictionary(contains: String) -> Bool {
        return dic?.contains(labels: englishStringToCharArray(string: contains)) ?? false
    }
    
    override func setUp() {
        super.setUp()
        
        do {
            dic = try DawgDictionary(fileName: Bundle(for: SwiftDawgTests.self).path(forResource: "dic-dawg-en", ofType: "bin")!)
        } catch {
            print("Error info: \(error)")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadValueData() {
        var a:Int32 = 10005000
        let data = withUnsafePointer(to: &a) {
            Data(bytes: UnsafePointer($0), count: MemoryLayout.size(ofValue: a))
        }
        let b:Int32 = data.getValueAt(position: 0)
        XCTAssert(a == b)
    }
    
    func testEnglishToArray() {
        let res = englishStringToCharArray(string: "aBC")
        XCTAssert(res == [1, 2, 3])
    }
    
    func testLoaded() {
        XCTAssert(dic != nil)
    }
    
    func testWords() {
        // good words
        XCTAssert(dictionary(contains: "true"))
        XCTAssert(dictionary(contains: "liberty"))
        XCTAssert(dictionary(contains: "international"))
        XCTAssert(dictionary(contains: "astronomy"))
        XCTAssert(dictionary(contains: "magazine"))
        
        // bad words
        XCTAssert(!dictionary(contains: ""))
        XCTAssert(!dictionary(contains: "erlgjlejgre"))
        XCTAssert(!dictionary(contains: "gogogogor"))
        XCTAssert(!dictionary(contains: "ijjjj"))
        XCTAssert(!dictionary(contains: "y"))
        XCTAssert(!dictionary(contains: "ijjjjfewofjwefljwelefjelewfjewlwjflwfhwelfhwflehwfewfejhfewljfhwefhewfhewfhewfkewhfkewhfewh"))
        
        // existring word written not up to the end
        XCTAssert(!dictionary(contains: "magazi")) // wants magazine
        XCTAssert(!dictionary(contains: "hamme")) // wants hammer
        XCTAssert(!dictionary(contains: "tremend")) // wants tremendous
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
