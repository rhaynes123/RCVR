//
//  RCVRUITests.swift
//  RCVRUITests
//
//  Created by richard Haynes on 4/6/24.
//

import XCTest

final class ContemplationUITests: XCTestCase {
    
    private var app : XCUIApplication!
    private var navigationstackhostingNavigationBar : XCUIElement!
    private var collectionViewsQuery : XCUIElementQuery!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        app.launch()
        app.buttons["My Activity And Trends"].tap()
        collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons["Contemplation"].tap()
        navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testCanCreateThenDeleteContemplation() throws {
        // Arrange
        let name = "Meditation"
        let asprinPredicate = NSPredicate(format: "label CONTAINS[c] '\(name)'")
        app.swipeUp()
        collectionViewsQuery.staticTexts["Add New Contemplation"].tap()
        // Act
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let asprinButton = collectionViewsQuery.buttons.containing(asprinPredicate).firstMatch
        asprinButton.swipeLeft()
        let deleteButton = collectionViewsQuery.buttons["Delete"]
                
        // Assert
        XCTAssertTrue(deleteButton.exists, "Delete button not found")
        
        // Tap the delete button
        deleteButton.tap()
        
    }
    
    func testContemplationOneTime() throws {
        // Arrange
        app.swipeUp()
        app.collectionViews.staticTexts["Add New Contemplation"].tap()
        
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        XCTAssertTrue(oneTime.waitForExistence(timeout: 5), "The 'onetime' switch does not exist.")
        XCTAssertTrue(oneTime.isHittable)
        // Act
        oneTime.tap()
        // Assert
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".otherElements[\"Log\"].buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".cells.buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["doneOrCancel"]/*[[".otherElements[\"Done\"]",".buttons[\"Done\"]",".buttons[\"doneOrCancel\"]",".otherElements[\"doneOrCancel\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testContemplationTrendsShow() throws {
        // Arrange
        app.collectionViews.staticTexts["Contemplation Trends"].tap()
        // Act
        // Assert
        XCTAssertTrue(app.otherElements["contemplationChart"].exists)
        
    }
    
    func testContemplationCanChange() throws {
        // Arrange
        collectionViewsQuery.staticTexts["Add New Contemplation"].tap()
        let techniquePicker = app.staticTexts["Meditation"].firstMatch
        techniquePicker.tap()
        // Act
        app.buttons["Prayer"].firstMatch.tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        oneTime.tap()
        // Assert
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".otherElements[\"Log\"].buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".cells.buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["doneOrCancel"]/*[[".otherElements[\"Done\"]",".buttons[\"Done\"]",".buttons[\"doneOrCancel\"]",".otherElements[\"doneOrCancel\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    
}
