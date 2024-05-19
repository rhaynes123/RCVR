//
//  WorkoutView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData
struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Workout]
    @State private var showSheet: Bool = false
    private var notificationManager:  NotificationManager = NotificationManager()
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let exercise : Workout = exercises[index]
                notificationManager.removeNotification(id: exercise.notificationId?.uuidString)
                modelContext.delete(exercise)
            }
        }
    }
    
    
    var body: some View {
        List {
            ForEach(exercises) { item in
                NavigationLink("\(item.exercise.rawValue) at \(item.timestamp, format: Date.FormatStyle(time: .shortened))", destination: LogWorkoutView(workout: item))
            }
            .onDelete(perform: deleteItems)
        }
       
        Button(action : {
            showSheet.toggle()
        }) {
            Label("Add New \(Category.exercise.rawValue)", systemImage: "figure.run")
        }
        .sheet(isPresented: $showSheet){
            workoutSheet(notificationManager: self.notificationManager)
        }
        .frame(width: 300, height: 50, alignment: .center)
            .background(Color.green)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
    
}

#Preview {
    let container = try! ModelContainer(for: Workout.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(Workout(timestamp: Date(), exercise: .chinUps, category: .exercise))
    container.mainContext.insert(Workout(timestamp: Date(), exercise: .crunches, category: .exercise))
    return WorkoutView().modelContainer(container)
}

