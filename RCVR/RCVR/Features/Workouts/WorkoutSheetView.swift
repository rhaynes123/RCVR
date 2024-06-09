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
    @State var isOneTime : Bool = false
    @Environment(NotificationManager.self) private var notificationManager: NotificationManager
    
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
                        Text(technique.rawValue).foregroundStyle(.primary)
                        
                    }
                    
                }
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                Section{
                    Toggle(isOn: $isOneTime){
                        Text("One Time")
                    }
                    .accessibilityIdentifier("isOneTime")
                } footer: {
                    Text("Choosing one time will prevent adding item to your list and a notification won't be made")
                }
                
            }.toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(isOneTime ? "Done" : "Cancel") {dismiss()}
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("doneOrCancel")
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
    let notificationManager: NotificationManager = NotificationManager()
    return workoutSheet()
        .environment(notificationManager)
        .modelContainer(container)
}
