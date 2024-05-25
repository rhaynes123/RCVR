//
//  ChartHelper.swift
//  RCVR
//
//  Created by richard Haynes on 5/25/24.
//

import Foundation
struct ChartHelper {
    
    static func getChartData(history: [WorkoutHistory]) -> [WorkoutChartData] {
        var data : [WorkoutChartData] = []
        for hist in history {
            if data.contains(where: {$0.exercise.rawValue == hist.exercise.rawValue}) {
                data.first{$0.exercise.rawValue == hist.exercise.rawValue}?.history.append(hist)
            } else {
                let chart : WorkoutChartData = WorkoutChartData(exercise: hist.exercise, history: [hist])
                data.append(chart)
            }
        }
        return data
    }
    
    static func getChartData(history: [ContemplationHistory]) -> [ContemplationChartData] {
        var dataDict = Dictionary<String, [ContemplationHistory]>()
        
        for hist in history {
            let technique = hist.technique.rawValue
            if var existinghistory = dataDict[technique]{
                existinghistory.append(hist)
                dataDict[technique] = existinghistory
            } else {
                dataDict[technique] = [hist]
            }
        }
        
        return dataDict.map {
            ContemplationChartData(contemplation: $0.key, history: $0.value)
        }
    }
    
    static func getChartData(history: [MedicationHistory]) -> [MedicalChartData] {
        var data : [MedicalChartData] = []
        for medicalData in history {
            if data.contains(where: {$0.medication == medicalData.title}) {
                data.first{$0.medication == medicalData.title}?.history.append(medicalData)
            } else {
                let chart : MedicalChartData = MedicalChartData(medication: medicalData.title, history: [medicalData])
                data.append(chart)
            }
        }
        return data
    }
}
final class WorkoutChartData: Identifiable {
    let exercise: Exercise
    var history: [WorkoutHistory]
    var id: String { exercise.rawValue }
    init(exercise: Exercise, history: [WorkoutHistory]) {
        self.exercise = exercise
        self.history = history
    }
}

final class ContemplationChartData: Identifiable {
    let contemplation: String
    var history: [ContemplationHistory]
    var id: String { contemplation }
    init(contemplation: String, history: [ContemplationHistory]) {
        self.contemplation = contemplation
        self.history = history
    }
}

final class MedicalChartData: Identifiable {
    let medication: String
    var history: [MedicationHistory]
    var id: String { medication }
    init(medication: String, history: [MedicationHistory]) {
        self.medication = medication
        self.history = history
    }
}
