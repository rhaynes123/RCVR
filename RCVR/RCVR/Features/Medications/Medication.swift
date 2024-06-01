//
//  Medication.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import Foundation
import SwiftData
@Model
final class Medication: Activity {
    var category: Category
    var administration : Administration
    var timestamp: Date
    var title: String
    var dose: Int
    var notificationId: UUID?
    init(timestamp: Date, administration: Administration, title: String, category: Category, dose: Int, notificationId : UUID = UUID()) {
        self.title = title
        self.administration = administration
        self.category = category
        self.timestamp = timestamp
        self.dose = dose
        self.notificationId = notificationId
    }
}

@Model
final class MedicationHistory: Chartable {
    var administration : Administration
    var dosageTime : Date
    var dose: Int
    var title: String
    init(administration: Administration, startTime: Date, dose: Int, title: String) {
        self.administration = administration
        self.dosageTime = startTime
        self.dose = dose
        self.title = title
    }
    
    func getChartId() -> String {
        return title
    }
}

enum Administration: String, Codable, CaseIterable {
    case pill = "Pill"
    case teaspoon = "Teaspoon"
    case injection = "Injection"
    case inhale = "Inhale"
    case topical = "Topical"
}

