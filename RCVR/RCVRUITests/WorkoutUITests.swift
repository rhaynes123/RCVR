//
//  WorkoutTests.swift
//  RCVRTests
//
//  Created by richard Haynes on 5/27/24.
//

import XCTest

final class WorkoutUITests: XCTestCase {
    private var app : XCUIApplication! = XCUIApplication()
    private var navigationstackhostingNavigationBar : XCUIElement!
    private var collectionViewsQuery : XCUIElementQuery!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
        app.launch()
        app.buttons["My Activity And Trends"].tap()
        collectionViewsQuery = app.collectionViews
        app.swipeUp()
        collectionViewsQuery.buttons["Exercise"].tap()
        navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    func testExerciseCanCancel() throws {
        collectionViewsQuery.staticTexts["Add New Exercise"].tap()
        
        let deleteButton = app.buttons["Cancel"]
        deleteButton.tap()
    }
    
    func testWorkoutTrendsShow() throws {
        // Arrange
        app.collectionViews.staticTexts["Exercise Trends"].tap()
        // Act
        // Assert
        XCTAssertTrue(app.otherElements["workoutChart"].exists)
    }
    
    func testCreateThenDeleteWorkouts() throws {
        // Arrange
        let pushUpsPredicate = NSPredicate(format: "label CONTAINS[c] 'Push ups'")
        // Act
        app.swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Add New Exercise"]/*[[".cells.buttons[\"Add New Exercise\"]",".buttons[\"Add New Exercise\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let pushUpsButton = collectionViewsQuery.buttons.containing(pushUpsPredicate).firstMatch
        pushUpsButton.swipeLeft()
        let deleteButton = collectionViewsQuery.buttons["Delete"]
                
        // Assert
        XCTAssertTrue(deleteButton.exists, "Delete button not found")
        
        // Tap the delete button
        deleteButton.tap()
    }
    func testCanSwitchToExerciseView() {
        // Arrange
        // Act
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Medication"]/*[[".cells",".segmentedControls.buttons[\"Medication\"]",".buttons[\"Medication\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Exercise"]/*[[".cells",".segmentedControls.buttons[\"Exercise\"]",".buttons[\"Exercise\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        // Assert
        XCTAssertTrue(collectionViewsQuery.staticTexts["Add New Exercise"].exists)
        
    }
    func testOneTimeWorkOut() throws {
        // Arrange
        
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add New Exercise"]/*[[".cells",".buttons[\"Add New Exercise\"].staticTexts[\"Add New Exercise\"]",".staticTexts[\"Add New Exercise\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        XCTAssertTrue(oneTime.waitForExistence(timeout: 5), "The 'onetime' switch does not exist.")
        XCTAssertTrue(oneTime.isHittable)
        // Act
        oneTime.tap()
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".otherElements[\"Log\"].buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let setsView = collectionViewsQuery/*@START_MENU_TOKEN@*/.cells.textFields["Sets:"]/*[[".cells.textFields[\"Sets:\"]",".textFields[\"Sets:\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        setsView.tap()
        setsView.typeText("1")
        
        let repsTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Reps:"]/*[[".cells.textFields[\"Reps:\"]",".textFields[\"Reps:\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        repsTextField.tap()
        repsTextField.typeText("3")
        // Assert
        app.swipeDown()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".cells.buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["doneOrCancel"].tap()
    }
    
    func testWorkOutCanNotLogNegatives() throws {
        // Arrange
        
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Exercise"]/*[[".cells",".segmentedControls.buttons[\"Exercise\"]",".buttons[\"Exercise\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery.staticTexts["Add New Exercise"].tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        XCTAssertTrue(oneTime.waitForExistence(timeout: 5), "The 'onetime' switch does not exist.")
        XCTAssertTrue(oneTime.isHittable)
        // Act
        oneTime.tap()
        
        navigationstackhostingNavigationBar.buttons["Log"].tap()
        let setsView = collectionViewsQuery.cells.textFields["Sets:"]
        setsView.tap()
        setsView.typeText("-1")
        
        let repsTextField = collectionViewsQuery.textFields["Reps:"]
        repsTextField.tap()
        repsTextField.typeText("-3")
        // Assert
        collectionViewsQuery.buttons["Log"].tap()
        XCTAssertFalse(collectionViewsQuery.buttons["Done"].exists)
    }
    
    func testContemplationCanChange() throws {
        // Arrange
        collectionViewsQuery.staticTexts["Add New Exercise"].tap()
        let techniquePicker = app.staticTexts["Push Ups"].firstMatch
        techniquePicker.tap()
        // Act
        app.buttons["Running"].firstMatch.tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        oneTime.tap()
        // Assert
        navigationstackhostingNavigationBar.buttons["Log"].tap()
        collectionViewsQuery.buttons["Log"].tap()
        app.buttons["doneOrCancel"].tap()
    }
    
    func testDurationExercisesDoNotHaveRepsAndSets() throws {
        // Arrange
        collectionViewsQuery.staticTexts["Add New Exercise"].tap()
        let techniquePicker = app.staticTexts["Push Ups"].firstMatch
        techniquePicker.tap()
        // Act
        app.buttons["Running"].firstMatch.tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        oneTime.tap()
        // Assert
        navigationstackhostingNavigationBar.buttons["Log"].tap()
        let setsView = collectionViewsQuery.cells.textFields["Sets:"]
        
        let repsTextField = collectionViewsQuery.textFields["Reps:"]
        XCTAssertFalse(setsView.exists, "Sets Exists")
        XCTAssertFalse(repsTextField.exists, "Reps Exists")
    }
    
    func testRepetionExercisesHaveRepsAndSets() throws {
        // Arrange
        collectionViewsQuery.staticTexts["Add New Exercise"].tap()
        let techniquePicker = app.staticTexts["Push Ups"].firstMatch
        techniquePicker.tap()
        // Act
        app.buttons["Squats"].firstMatch.tap()
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        oneTime.tap()
        // Assert
        navigationstackhostingNavigationBar.buttons["Log"].tap()
        let setsView = collectionViewsQuery.cells.textFields["Sets:"]
        
        let repsTextField = collectionViewsQuery.textFields["Reps:"]
        XCTAssertTrue(setsView.exists, "Sets Do Not Exists")
        XCTAssertTrue(repsTextField.exists, "Reps Do Not Exists")
    }

    
}
