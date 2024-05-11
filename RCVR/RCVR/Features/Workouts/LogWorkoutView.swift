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
    
    var workout : Workout
    init(workout: Workout) {
        self.workout = workout
    }
    
    private func log(entry: WorkoutHistory){
        if sets < 0 {
            return
        }
        if reps < 0 {
            return
        }
        modelContext.insert(entry)
        dismiss()
    }
    var body: some View {
        VStack {
            Form {
                Text("Name: \(workout.exercise.rawValue)")
                
                Section {
                    TextField("Sets:", value: $sets, format: .number)
                } header: {
                    Text("Sets")
                } footer: {
                    Text("Sets can not be less than zero")
                        .foregroundStyle(.red)
                }
                
                Section {
                    TextField("Reps:", value: $reps, format: .number)
                } header: {
                    Text("Reps")
                } footer: {
                    Text("Reps can not be less than zero")
                        .foregroundStyle(.red)
                }
                
                DatePicker("Start Time", selection: $startTime)
                DatePicker("End Time", selection: $endTime)
                
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
