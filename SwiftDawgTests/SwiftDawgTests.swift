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
            dic = try DawgDictionary(url: Bundle(for: SwiftDawgTests.self).url(forResource: "dic-dawg-en", withExtension: "bin")!)
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
    
    func testSaveDictionary() {
        if dic != nil {
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if let directory:URL = urls.first {
                let fileURL = directory.appendingPathComponent("test.bin")
                let fileName = fileURL.absoluteString
                if FileManager.default.fileExists(atPath: fileName) {
                    try? FileManager.default.removeItem(at: fileURL)
                }
                
                try! dic?.save(to: fileURL)
                
                let saved = try? DawgDictionary(url: fileURL)
                XCTAssert(saved != nil)
               
                XCTAssert(saved!.units == dic!.units)
            }
            
        }
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
    
}
