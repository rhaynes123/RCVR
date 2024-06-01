//
//  RCVRTests.swift
//  RCVRTests
//
//  Created by richard Haynes on 4/6/24.
//

import XCTest
@testable import RCVR
import SwiftData

final class RCVRTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWorkoutChartShouldGroupTogetherDataByExercise() throws {
        // Arrange
        let expected = 2
        let testHistoryData : [WorkoutHistory] = [
            WorkoutHistory(exercise: .bicepCurl, startTime: Date(), endTime: Date(), sets: 3, reps: 5),
            WorkoutHistory(exercise: .bicepCurl, startTime: Date(), endTime: Date(), sets: 3, reps: 5),
            WorkoutHistory(exercise: .chinUps, startTime: Date(), endTime: Date(), sets: 4, reps: 5)
        ]
        // Act
        let actual = ChartHelper.getChartData(history: testHistoryData)
        // Assert
        XCTAssertEqual(actual.count, expected)
    }
    
    func testContemplationChartShouldGroupTogetherDataByTechnique() throws {
        // Arrange
        let expected = 2
        let testHistoryData : [ContemplationHistory] = [
            ContemplationHistory(technique: .deepBreath, startTime: Date(), endTime: Date()),
            ContemplationHistory(technique: .deepBreath, startTime: Date(), endTime: Date()),
            ContemplationHistory(technique: .prayer, startTime: Date(), endTime: Date())
        ]
        // Act
        let actual = ChartHelper.getChartData(history: testHistoryData)
        // Assert
        XCTAssertEqual(actual.count, expected)
    }
    
    func testMedicationChartShouldGroupTogetherDataByTitle() throws {
        // Arrange
        let expected = 2
        let testHistoryData : [MedicationHistory] = [
            MedicationHistory(administration: .injection, startTime: Date(), dose: 1, title: "Insulin"),
            MedicationHistory(administration: .injection, startTime: Date(), dose: 1, title: "insulin"),
            MedicationHistory(administration: .injection, startTime: Date(), dose: 1, title: "Steriods")
        ]
        // Act
        let actual = ChartHelper.getChartData(history: testHistoryData)
        // Assert
        XCTAssertEqual(actual.count, expected)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
