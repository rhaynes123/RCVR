//
//  WorkoutHistoryView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData
import Charts
struct WorkoutHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var history: [WorkoutHistory]
    
    // MARK: Begin Private Methods
    private func getChartData(history: [WorkoutHistory]) -> [WorkoutChartData] {
        var data : [WorkoutChartData] = []
        for hist in history {
            if data.contains(where: {$0.exercise == hist.exercise.rawValue}) {
                data.first{$0.exercise == hist.exercise.rawValue}?.history.append(hist)
            } else {
                let chart : WorkoutChartData = WorkoutChartData(exercise: hist.exercise.rawValue, history: [hist])
                data.append(chart)
            }
        }
        return data
    }
    // MARK: End Private Methods
    var body: some View {
        VStack {
            Text("Workouts Completed")
            let totalReps = history.reduce(0){$0 + ($1.reps * $1.sets)}
            let lastworkout : WorkoutHistory?  = history.last
            let histData : [WorkoutChartData] = getChartData(history: self.history)
            Text("\(totalReps) total reps as of \(lastworkout?.endTime ?? Date(), format: Date.FormatStyle(date: .abbreviated))")
                .font(.footnote)
            Chart(histData, id: \.exercise)  {hisDat in
               
                ForEach(hisDat.history){ workout in
                    LineMark(
                        x: .value("Exercise StartTime", workout.startTime) ,
                        y: .value("Total Reps", workout.reps)
                    )
                    
                }.foregroundStyle(by: .value("Exercise", hisDat.exercise))
                    .symbol(by: .value("Exercise", hisDat.exercise))
            }
        }
        
        List(history){ workout in
            Text("\(workout.sets) sets x \(workout.reps) reps of \(workout.exercise.rawValue) done between \(workout.startTime, format: Date.FormatStyle(date:.numeric, time: .shortened)) and \(workout.endTime, format: Date.FormatStyle(date:.numeric, time: .shortened))")
            
        }
    }
}

final class WorkoutChartData: Identifiable {
    let exercise: String
    var history: [WorkoutHistory]
    var id: String { exercise }
    init(exercise: String, history: [WorkoutHistory]) {
        self.exercise = exercise
        self.history = history
    }
}

#Preview {
    let container = try! ModelContainer(for: WorkoutHistory.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    for index in 0...5 {
        container.mainContext.insert(WorkoutHistory(exercise: .crunches, startTime: Date(), endTime: Date(), sets: index, reps: index))
    }
    for index in 0...15 {
        container.mainContext.insert(WorkoutHistory(exercise: .lunges, startTime: Date(), endTime: Date(), sets: index, reps: index))
    }
    return WorkoutHistoryView().modelContainer(container)
}
