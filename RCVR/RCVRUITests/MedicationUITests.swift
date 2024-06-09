//
//  MedicationUITests.swift
//  RCVRUITests
//
//  Created by richard Haynes on 5/27/24.
//

import XCTest

final class MedicationUITests: XCTestCase {
    private var app : XCUIApplication! = XCUIApplication()
    private var navigationstackhostingNavigationBar : XCUIElement!
    private var collectionViewsQuery : XCUIElementQuery!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()
        
        app.buttons["My Activity And Trends"].tap()
        collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons["Medication"].tap()
        navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    func testMedicationTrendsShow() throws {
        // Arrange
        app.collectionViews.staticTexts["Medication Trends"].tap()
        // Act
        // Assert
        XCTAssertTrue(app.otherElements["medicationChart"].exists)
    }
    
    func testCanCreateThenDeleteMedication() throws {
        // Arrange
        let name = "Asprin"
        let asprinPredicate = NSPredicate(format: "label CONTAINS[c] '\(name)'")
       
        // Act
        app.swipeUp()
        collectionViewsQuery.staticTexts["Add New Medication"].tap()
        let medicationName = collectionViewsQuery.textFields["Medication Name"]
        medicationName.tap()
        medicationName.typeText(name)
        
        
        navigationstackhostingNavigationBar.buttons["Save"].tap()
        let asprinButton = collectionViewsQuery.buttons.containing(asprinPredicate).firstMatch
        asprinButton.swipeLeft()
        let deleteButton = collectionViewsQuery.buttons["Delete"]
                
        // Assert
        XCTAssertTrue(deleteButton.exists, "Delete button not found")
        
        // Tap the delete button
        deleteButton.tap()
    }
    
    func testMedicationOneTime() throws {
        // Arrange
        app.swipeUp()
        app.collectionViews.staticTexts["Add New Medication"].tap()
        
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        XCTAssertTrue(oneTime.waitForExistence(timeout: 5), "The 'onetime' switch does not exist.")
        XCTAssertTrue(oneTime.isHittable)
        // Act
        oneTime.tap()
        let name = collectionViewsQuery.textFields["Medication Name"]
        name.tap()
        name.typeText("Vitamin D")
       
        // Assert
        navigationstackhostingNavigationBar.buttons["Log"].tap()
        app.buttons["Log"].tap()
        navigationstackhostingNavigationBar.buttons["doneOrCancel"].tap()
    }
    
    func testMedicationCanNotHaveZeroDose() throws {
        // Arrange
        
        collectionViewsQuery.staticTexts["Add New Medication"].tap()
        let doseElement = collectionViewsQuery.textFields["Dose"]
        
        for val in -1...0 {
            doseElement.tap()
            doseElement.typeText(String(XCUIKeyboardKey.delete.rawValue))
            doseElement.typeText(String(XCUIKeyboardKey.delete.rawValue))
            doseElement.typeText("\(val)")
            // Assert
            let saveButton = navigationstackhostingNavigationBar.buttons["Save"]
            saveButton.tap()
            XCTAssertTrue(saveButton.exists)
        }
       
        navigationstackhostingNavigationBar.buttons["doneOrCancel"].tap()
        
    }
    
    func testMedicationMustHaveAName() throws {
        // Arrange
        // Act
        collectionViewsQuery.staticTexts["Add New Medication"].tap()
        let medicationElement : XCUIElement = collectionViewsQuery.textFields["Medication Name"]
        medicationElement.tap()
        medicationElement.typeText(String(XCUIKeyboardKey.delete.rawValue))
        medicationElement.typeText("")
        // Assert
        let saveButton = navigationstackhostingNavigationBar.buttons["Save"]
        saveButton.tap()
        XCTAssertTrue(saveButton.exists)
        navigationstackhostingNavigationBar.buttons["doneOrCancel"].tap()
    }

}
