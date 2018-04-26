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

        let thing = SomeType(id: "1")
        
        let thing2 = SomeType(id: "2")
        
        let wing = SomeOtherType(id: "3")
        
        ERModelCache.shared.add(model: thing)
        
        ERModelCache.shared.add(model: thing2)
        
        ERModelCache.shared.add(model: wing)
        
        XCTAssertEqual(SomeType.allModelsInCache().count, 2)
        
        XCTAssertEqual(SomeOtherType.allModelsInCache().count, 1)
        
        XCTAssertEqual(thing, ERModelCache.shared.getModelWith(id: "1"))
        
        XCTAssertEqual(thing2, ERModelCache.shared.getModelWith(id: "2"))
        
        XCTAssertEqual(wing, ERModelCache.shared.getModelWith(id: "3"))
        
        ERModelCache.shared.clearAllData()
        
        XCTAssertEqual(SomeType.allModelsInCache().count, 0)
        
        XCTAssertEqual(SomeOtherType.allModelsInCache().count, 0)
    }
}
