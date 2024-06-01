//
//  RCVRUITests.swift
//  RCVRUITests
//
//  Created by richard Haynes on 4/6/24.
//

import XCTest

final class ContemplationUITests: XCTestCase {
    
    private var app : XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        app.launch()
        app.buttons["My Activity And Trends"].tap()
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
        let collectionViewsQuery = app.collectionViews
        app.swipeUp()
        collectionViewsQuery.staticTexts["Add New Contemplation"].tap()
        // Act
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let asprinButton = collectionViewsQuery.buttons.containing(asprinPredicate).firstMatch
        asprinButton.swipeLeft()
        let deleteButton = collectionViewsQuery.buttons["Delete"]
                
        // Assert
        XCTAssertTrue(deleteButton.exists, "Delete button not found")
        
        // Tap the delete button
        deleteButton.tap()
        
    }
    
    func testContemplationTrendsShow() throws {
        // Arrange
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Contemplation Trends"]/*[[".cells",".buttons[\"Contemplation Trends\"].staticTexts[\"Contemplation Trends\"]",".staticTexts[\"Contemplation Trends\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        // Act
        // Assert
        XCTAssertTrue(app.otherElements["contemplationChart"].exists)
        //XCTAssertTrue(app.otherElements["contemplationList"].exists)
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
