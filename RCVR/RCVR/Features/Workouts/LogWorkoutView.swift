//
//  LogWorkoutView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//
import SwiftUI
import SwiftData
struct LogWorkoutView : View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var exercises: [WorkoutHistory]
    @State private var startTime : Date = Date()
    @State private var endTime : Date = Date()
    @State private var sets: Int = 0
    @State private var reps: Int = 0
    @State private var hasErrors : Bool = false
    var workout : Workout
    init(workout: Workout) {
        self.workout = workout
    }
    
    private func formIsInValid() -> Bool {
        switch self.workout.exercise.measurement {
        case .duration:
            return endTime < startTime
        case .repsAndSets:
            return sets <= 0 || reps <= 0 || endTime < startTime
        }
    }
    private func log(entry: WorkoutHistory){
        if formIsInValid() {
            hasErrors.toggle()
            return
        }
       
        modelContext.insert(entry)
        dismiss()
    }
    var body: some View {
        VStack {
            Form {
                Text("Name: \(workout.exercise.rawValue)")
                
                if workout.exercise.measurement == .repsAndSets{
                    Section {
                        TextField("Sets:", value: $sets, format: .number)
                            .keyboardType(.numberPad)
                    } header: {
                        Text("Sets")
                    } footer: {
                        Text("Sets can not be zero")
                            .foregroundStyle( hasErrors ? .red : .secondary)
                    }
                    
                    Section {
                        TextField("Reps:", value: $reps, format: .number)
                            .keyboardType(.numberPad)
                    } header: {
                        Text("Reps")
                    } footer: {
                        Text("Reps can not be zero")
                            .foregroundStyle( hasErrors ? .red : .secondary)
                    }
                }
                
                
                Section {
                    DatePicker("Start Time", selection: $startTime)
                    DatePicker("End Time", selection: $endTime)
                } footer: {
                    Text("End can not be before start")
                        .foregroundStyle( hasErrors ? .red : .secondary)
                }
                
                Button("Log"){
                    let entry = WorkoutHistory(exercise: workout.exercise, startTime: startTime, endTime: endTime, sets: sets, reps: reps)
                    log(entry: entry)
                    
                }
            }
        }
    }
    
}

#Preview {
    let container = try! ModelContainer(for: WorkoutHistory.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let workout = Workout(timestamp: Date(), exercise: .lunges , category: .exercise)
    return LogWorkoutView(workout: workout).modelContainer(container)
}
