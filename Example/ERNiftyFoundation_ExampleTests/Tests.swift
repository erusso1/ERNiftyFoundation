//
//  ERNiftyFoundation_ExampleTests.swift
//  ERNiftyFoundation_ExampleTests
//
//  Created by Ephraim Russo on 4/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import ERNiftyFoundation
import Unbox
import Wrap

class SomeType: ERModelType {
    
    var id: String
    
    init(id: String) {
       
        self.id = id
    }
    
    required init(unboxer: Unboxer) throws {
        
        self.id = try unboxer.unbox(key: "id")
    }
}

class SomeOtherType: ERModelType {
    
    var id: String
    
    init(id: String) {
        
        self.id = id
    }
    
    required init(unboxer: Unboxer) throws {
        
        self.id = try unboxer.unbox(key: "id")
    }
}


class ERNiftyFoundation_ExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testModelCache() {
        
        ERModelCache.logsCaching = true
        
        let allModels0: [SomeType] = ERModelCache.shared.allModels()
        
        print(allModels0)
        
        let thing1 = SomeType(id: "1")
        
        let thing2 = SomeOtherType(id: "2")
        
        ERModelCache.shared.add(model: thing1)
        
        ERModelCache.shared.add(model: thing2)
        
        let allModels1: [SomeType] = ERModelCache.shared.allModels()
        
        XCTAssertTrue(allModels1.count == 1, "A")
        
        let allModels2: [SomeOtherType] = ERModelCache.shared.allModels()
        
        XCTAssertTrue(allModels2.count == 1, "B")
        
        printPretty(ERModelCache.userDefaultsStore.dictionaryRepresentation())
        
        ERModelCache.shared.clearAllData()
        
        printPretty(ERModelCache.userDefaultsStore.dictionaryRepresentation())

//        let newModels1: [SomeType] = ERModelCache.shared.allModels()
//
//        XCTAssertTrue(newModels1.isEmpty, "C")
//
//        let newModels2: [SomeOtherType] = ERModelCache.shared.allModels()
//
//        XCTAssertTrue(newModels2.isEmpty, "D")
//
//        printPretty(ERModelCache.userDefaultsStore.dictionaryRepresentation())

    }    
}
