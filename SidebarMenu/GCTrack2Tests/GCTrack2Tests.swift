//
//  GCTrack2Tests.swift
//  GCTrack2Tests
//
//  Created by user on 1/30/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import XCTest

class GCTrack2Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    print("setupeando")
     self.continueAfterFailure = false
    
    
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    print("testeando")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
            print("performeando")
            // Put the code you want to measure the time of here.
       
        
        
        }
    }
    
}
