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
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Medication"]/*[[".cells",".segmentedControls.buttons[\"Medication\"]",".buttons[\"Medication\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
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
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add New Medication"]/*[[".cells",".buttons[\"Add New Medication\"].staticTexts[\"Add New Medication\"]",".staticTexts[\"Add New Medication\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let medicationName = collectionViewsQuery.textFields["Medication Name"]
        medicationName.tap()
        medicationName.typeText(name)
        
        
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
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
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Add New Medication"]/*[[".cells",".buttons[\"Add New Medication\"].staticTexts[\"Add New Medication\"]",".staticTexts[\"Add New Medication\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let oneTime = app.switches["isOneTime"].switches.firstMatch
        XCTAssertTrue(oneTime.waitForExistence(timeout: 5), "The 'onetime' switch does not exist.")
        XCTAssertTrue(oneTime.isHittable)
        // Act
        oneTime.tap()
        let name = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Medication Name"]/*[[".cells.textFields[\"Medication Name\"]",".textFields[\"Medication Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        name.tap()
        name.typeText("Vitamin D")
       
        // Assert
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".otherElements[\"Log\"].buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Log"]/*[[".cells.buttons[\"Log\"]",".buttons[\"Log\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["doneOrCancel"]/*[[".otherElements[\"Done\"]",".buttons[\"Done\"]",".buttons[\"doneOrCancel\"]",".otherElements[\"doneOrCancel\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
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
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add New Medication"]/*[[".cells",".buttons[\"Add New Medication\"].staticTexts[\"Add New Medication\"]",".staticTexts[\"Add New Medication\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
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
