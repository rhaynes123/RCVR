//
//  RCVRUITests.swift
//  RCVRUITests
//
//  Created by richard Haynes on 4/6/24.
//

import XCTest

final class RCVRUITests: XCTestCase {
    
    private var app : XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        app.launch()
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testCreateWorkouts() throws {
        // Arrange
        
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add New Exercise"]/*[[".cells",".buttons[\"Add New Exercise\"].staticTexts[\"Add New Exercise\"]",".staticTexts[\"Add New Exercise\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Push Ups"]/*[[".cells",".buttons[\"Exercise, Push Ups\"].staticTexts[\"Push Ups\"]",".staticTexts[\"Push Ups\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let crunchesButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Crunches"]/*[[".cells.buttons[\"Crunches\"]",".buttons[\"Crunches\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        crunchesButton.tap()
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        crunchesButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Sets:"]/*[[".cells.textFields[\"Sets:\"]",".textFields[\"Sets:\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let repsTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Reps:"]/*[[".cells.textFields[\"Reps:\"]",".textFields[\"Reps:\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        repsTextField.tap()
        repsTextField.tap()
        app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".cells.buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // Act
                
        // Assert
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
