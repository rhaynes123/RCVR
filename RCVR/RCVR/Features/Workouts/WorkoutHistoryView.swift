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
    @Query(sort:[SortDescriptor(\WorkoutHistory.endTime, order: .reverse)]
            , animation: .snappy) private var history: [WorkoutHistory]
    
    // MARK: Begin Private Methods
    
    
    // MARK: End Private Methods
    var body: some View {
        VStack {
            Text("Workouts Completed")
            let totalReps = history.reduce(0){$0 + ($1.reps * $1.sets)}
            let lastworkout : WorkoutHistory?  = history.last
            let histData : [WorkoutChartData] = ChartHelper.getChartData(history: self.history)
            
            Text("\(totalReps) total reps as of \(lastworkout?.endTime ?? Date(), format: Date.FormatStyle(date: .abbreviated))")
                .font(.footnote)
            
            Chart(histData, id: \.id) { hisDat in
               
                ForEach(hisDat.history){ workout in
                    if workout.exercise.measurement == .duration {
                        let totalDuration = (workout.endTime.timeIntervalSince(workout.startTime) / 60)
                        LineMark(
                            x: .value("Exercise StartTime", workout.startTime) ,
                            y: .value("Total Duration", totalDuration)
                        ).annotation(position: .top,
                                     alignment: .leading,
                                     spacing: 4){
                            Text("Minutes \(workout.exercise.rawValue)")
                                .font(.footnote)
                        }
                    }
                    else {
                        LineMark(
                            x: .value("Exercise StartTime", workout.startTime) ,
                            y: .value("Total Reps", workout.reps)
                        )
                    }
                    
                    
                }.foregroundStyle(by: .value("Exercise", hisDat.id))
                    .symbol(by: .value("Exercise", hisDat.id))
            }
        }
        
        List(history){ workout in
            
            switch workout.exercise.measurement {
            case .duration:
                Text("\(workout.exercise.rawValue) done between \(workout.startTime, format: Date.FormatStyle(date:.numeric, time: .shortened)) and \(workout.endTime, format: Date.FormatStyle(date:.numeric, time: .shortened))")
            case .repsAndSets:
                Text("\(workout.sets) sets x \(workout.reps) reps of \(workout.exercise.rawValue) done at \(workout.endTime, format: Date.FormatStyle(date:.numeric, time: .shortened))")
            }
            
            
        }
    }
}



#Preview {
    let container = try! ModelContainer(for: WorkoutHistory.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for index in 0...5 {
        container.mainContext.insert(WorkoutHistory(exercise: .crunches, startTime: Date(), endTime: Date(), sets: index, reps: index))
        
        container.mainContext.insert(WorkoutHistory(exercise: .running, startTime: Date().addingTimeInterval(-10000000), endTime: Date(), sets: 0, reps: 0))
    }
    for index in 0...15 {
        container.mainContext.insert(WorkoutHistory(exercise: .lunges, startTime: Date(), endTime: Date(), sets: index, reps: index))
    }
    return WorkoutHistoryView().modelContainer(container)
}
