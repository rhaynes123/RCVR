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
        app.buttons["My Activity And Trends"].tap()
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testCreateThenDeleteWorkouts() throws {
        // Arrange
        let pushUpsPredicate = NSPredicate(format: "label CONTAINS[c] 'Push ups'")
        let collectionViewsQuery = app.collectionViews
        
        // Act
        app.swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Add New Exercise"]/*[[".cells.buttons[\"Add New Exercise\"]",".buttons[\"Add New Exercise\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let ttgc7swiftui32navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let pushUpsButton = collectionViewsQuery.buttons.containing(pushUpsPredicate).firstMatch
        pushUpsButton.swipeLeft()
        let deleteButton = collectionViewsQuery.buttons["Delete"]
                
        // Assert
        XCTAssertTrue(deleteButton.exists, "Delete button not found")
        
        // Tap the delete button
        deleteButton.tap()
    }
    
    func testCanCreateThenDeleteMedication() throws {
        // Arrange
        let name = "Asprin"
        let asprinPredicate = NSPredicate(format: "label CONTAINS[c] '\(name)'")
        let collectionViewsQuery = app.collectionViews
        
        // Act
        app.swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add New Medication"]/*[[".cells",".buttons[\"Add New Medication\"].staticTexts[\"Add New Medication\"]",".staticTexts[\"Add New Medication\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let medicationName = collectionViewsQuery.textFields["Medication Name"]
        medicationName.tap()
        medicationName.typeText(name)
        
        
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let asprinButton = collectionViewsQuery.buttons.containing(asprinPredicate).firstMatch
        asprinButton.swipeLeft()
        let deleteButton = collectionViewsQuery.buttons["Delete"]
                
        // Assert
        XCTAssertTrue(deleteButton.exists, "Delete button not found")
        
        // Tap the delete button
        deleteButton.tap()
        
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
    
    func testExerciseCanCancel() throws {
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Add New Exercise"].tap()
        
        let deleteButton = app.buttons["Cancel"]
        deleteButton.tap()
    }
    
    func testOneTimeWorkOut() throws {
        // Arrange
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add New Exercise"]/*[[".cells",".buttons[\"Add New Exercise\"].staticTexts[\"Add New Exercise\"]",".staticTexts[\"Add New Exercise\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        XCTAssertTrue(oneTime.waitForExistence(timeout: 5), "The 'onetime' switch does not exist.")
        XCTAssertTrue(oneTime.isHittable)
        // Act
        oneTime.tap()
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".otherElements[\"Log\"].buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let setsView = collectionViewsQuery/*@START_MENU_TOKEN@*/.cells.textFields["Sets:"]/*[[".cells.textFields[\"Sets:\"]",".textFields[\"Sets:\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        setsView.tap()
        setsView.typeText("1")
        
        let repsTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Reps:"]/*[[".cells.textFields[\"Reps:\"]",".textFields[\"Reps:\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        repsTextField.tap()
        repsTextField.typeText("3")
        
        
                
        
        // Assert
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".cells.buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["doneOrCancel"].tap()
    }
    
    func testWorkOutCanNotLogNegatives() throws {
        // Arrange
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add New Exercise"]/*[[".cells",".buttons[\"Add New Exercise\"].staticTexts[\"Add New Exercise\"]",".staticTexts[\"Add New Exercise\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        XCTAssertTrue(oneTime.waitForExistence(timeout: 5), "The 'onetime' switch does not exist.")
        XCTAssertTrue(oneTime.isHittable)
        // Act
        oneTime.tap()
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".otherElements[\"Log\"].buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let setsView = collectionViewsQuery/*@START_MENU_TOKEN@*/.cells.textFields["Sets:"]/*[[".cells.textFields[\"Sets:\"]",".textFields[\"Sets:\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        setsView.tap()
        setsView.typeText("-1")
        
        let repsTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Reps:"]/*[[".cells.textFields[\"Reps:\"]",".textFields[\"Reps:\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        repsTextField.tap()
        repsTextField.typeText("-3")
        
        // Assert
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".cells.buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(collectionViewsQuery.buttons["Done"].exists)
    }
    
    
    func testContemplationTrendsShow() throws {
        // Arrange
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Contemplation Trends"]/*[[".cells",".buttons[\"Contemplation Trends\"].staticTexts[\"Contemplation Trends\"]",".staticTexts[\"Contemplation Trends\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        // Act
        // Assert
        XCTAssertTrue(app.otherElements["contemplationChart"].exists)
        //XCTAssertTrue(app.otherElements["contemplationList"].exists)
        
    }
    
    func testWorkoutTrendsShow() throws {
        // Arrange
        app.collectionViews.staticTexts["Exercise Trends"].tap()
        // Act
        // Assert
        XCTAssertTrue(app.otherElements["workoutChart"].exists)
    }
    
    func testMedicationTrendsShow() throws {
        // Arrange
        app.collectionViews.staticTexts["Medication Trends"].tap()
        // Act
        // Assert
        XCTAssertTrue(app.otherElements["medicationChart"].exists)
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
