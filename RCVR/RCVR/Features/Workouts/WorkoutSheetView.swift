//
//  WorkoutSheetView.swift
//  RCVR
//
//  Created by richard Haynes on 5/18/24.
//

import SwiftUI
import SwiftData
struct workoutSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var exercise : Exercise = .pushUp
    @State var time : Date = Date()
    @State private var isOneTime : Bool = false
    var notificationManager:  NotificationManager
    
    init(notificationManager:  NotificationManager){
        self.notificationManager = notificationManager
    }
    private func addItem(newItem: Workout) {
        withAnimation {
            modelContext.insert(newItem)
            if let notificationId = newItem.notificationId {
                notificationManager.scheduleNotifications(from: newItem.timestamp, id: notificationId, subTitle: "Time for \(newItem.exercise.rawValue)")
            }
            
            dismiss()
        }
    }

    var body: some View {
            NavigationStack {
            Form {
                Picker("Exercise", selection: $exercise){
                    ForEach(Exercise.allCases, id: \.self) {technique in
                        Text(technique.rawValue)
                        
                    }
                    
                }
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                Section{
                    Toggle("One Time", isOn: $isOneTime)
                } footer: {
                    Text("Choosing one time will prevent adding item to your list and a notification won't be made")
                }
                
            }.toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {dismiss()}
                        .buttonStyle(.bordered)
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    let workout = Workout(timestamp: time, exercise: exercise, category: .exercise)
                    if isOneTime {
                        NavigationLink("Log"){
                            LogWorkoutView(workout: workout)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    else {
                        Button("Save") {
                            addItem(newItem: workout)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Workout.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return workoutSheet(notificationManager: NotificationManager()).modelContainer(container)
}
