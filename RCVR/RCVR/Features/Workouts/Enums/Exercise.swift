//
//  Exercise.swift
//  RCVR
//
//  Created by richard Haynes on 5/18/24.
//

import Foundation
enum Exercise: String, Codable, CaseIterable {
    case pushUp = "Push Ups"
    case crunches = "Crunches"
    case lunges = "Lunges"
    case hipthrusts = "Hip Thrusts"
    case squats = "Squats"
    case walking = "Walking"
    case running = "Running"
    case calfraises = "Calf Raises"
    case bicepCurl = "Bicep Curl"
    case pullups = "Pull Ups"
    case wallPushUp = "Wall Push Ups"
    case chinUps = "Chin Ups"
    case benchPress = "Bench Press"
    
    var measurement : Measurement {
        switch self {
        case .running, .walking:
            return .duration
        default:
            return .repsAndSets
        }
    }
}

enum Measurement: String {
    case duration = "duration"
    case repsAndSets = "reps"
}
