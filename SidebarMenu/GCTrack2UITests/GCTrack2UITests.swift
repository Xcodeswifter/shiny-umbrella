//
//  GCTrack2UITests.swift
//  GCTrack2UITests
//
//  Created by user on 1/30/17.

//  Copyright © 2017 AppCoda. All rights reserved.
//

import XCTest

class GCTrack2UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        
        let shiftButton = app.buttons["shift"]
        shiftButton.tap()
        shiftButton.tap()
        usernameTextField.typeText("X")
        
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        usernameTextField.typeText("CARLOS")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        shiftButton.tap()
        shiftButton.tap()
        passwordSecureTextField.typeText("T")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.buttons["Untitled 1 0001 Layer 1"].tap()
        app.tables.staticTexts["GCT Software Test Location 2"].tap()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        
        let app = XCUIApplication()
        app.buttons["GC-Dev 991"].tap()
        app.tables.staticTexts["GC-Dev 992"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 4).tap()
        app.buttons["pressurehistory"].tap()
        app.buttons["botongoback"].tap()
        
    
    }
    
}
