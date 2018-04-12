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
        
        ERModelCache.shared.clearAllData()
        
        let thing1 = SomeType(id: "1")
        
        let thing2 = SomeOtherType(id: "2")
        
        ERModelCache.shared.add(model: thing1)
        
        ERModelCache.shared.add(model: thing2)
        
        let allModels1: [SomeType] = ERModelCache.shared.allModels()
        
        let allModelsB = SomeType.allModelsInCache()
        
        XCTAssertTrue(allModels1.count == 1, "A")
        
        XCTAssertEqual(allModels1, allModelsB)
        
        let allModels2: [SomeOtherType] = ERModelCache.shared.allModels()
        
        let modelC = SomeOtherType.getModelInCacheWith(id: "2")
        
        XCTAssertTrue(allModels2.count == 1, "B")
        
        XCTAssertEqual(allModels2, [modelC!])
        
        ERModelCache.shared.clearAllData()
    }    
}
