//
//  Workout.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import Foundation
import SwiftData


@Model
final class Workout: Activity {
    var category: Category
    
    var timestamp: Date
    var exercise: Exercise
    var notificationId: UUID?
    init(timestamp: Date, exercise: Exercise, category: Category, notificationId: UUID? = UUID()) {
        self.exercise = exercise
        self.category = category
        self.timestamp = timestamp
        self.notificationId = notificationId
    }
}

@Model
final class WorkoutHistory {
    var exercise: Exercise
    var startTime : Date
    var endTime : Date
    var sets: Int
    var reps: Int
    init(exercise: Exercise, startTime: Date, endTime: Date, sets: Int, reps: Int) {
        self.exercise = exercise
        self.startTime = startTime
        self.endTime = endTime
        self.sets = sets
        self.reps = reps
    }
}

