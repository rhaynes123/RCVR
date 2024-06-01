//
//  Contemplation.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import Foundation
import SwiftData
@Model
final class Contemplation: Activity {
    var category: Category
    var timestamp: Date
    var technique: Technique
    var notificationId: UUID?
    init(timestamp: Date, category: Category, technique: Technique, notificationId: UUID = UUID()) {
        
        self.category = category
        self.timestamp = timestamp
        self.technique = technique
        self.notificationId = notificationId
    }
    
}

@Model
final class ContemplationHistory: Chartable {
    var technique: Technique
    var startTime : Date
    var endTime : Date
    init(technique: Technique, startTime: Date, endTime: Date) {
        self.technique = technique
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func getChartId() -> String {
        return technique.rawValue
    }
}

enum Technique: String, CaseIterable, Codable {
    case meditation = "Meditation"
    case deepBreath = "Deep Breathing"
    case mindfulness = "Mindfulness"
    case prayer = "Prayer"
}
