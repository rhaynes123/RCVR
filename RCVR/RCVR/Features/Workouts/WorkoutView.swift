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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(exercises[index])
            }
        }
    }
    
    
    var body: some View {
        List {
            ForEach(exercises) { item in
                NavigationLink("\(item.exercise.rawValue)", destination: LogWorkoutView(workout: item))
            }
            .onDelete(perform: deleteItems)
        }
       
        Button(action : {
            showSheet.toggle()
        }) {
            Label("Add New \(Category.exercise.rawValue)", systemImage: "figure.run")
        }
        .sheet(isPresented: $showSheet){
            workoutSheet()
        }
        .frame(width: 300, height: 50, alignment: .center)
            .background(Color.green)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
    
}
struct workoutSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var exercise : Exercise = .pushUp
    private func addItem(newItem: Workout) {
        withAnimation {
            modelContext.insert(newItem)
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
                
                
            }.toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {dismiss()}
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let workout = Workout(timestamp: Date(), exercise: exercise, category: .exercise)
                        addItem(newItem: workout)
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    let container = try! ModelContainer(for: Workout.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(Workout(timestamp: Date(), exercise: .chinUps, category: .exercise))
    container.mainContext.insert(Workout(timestamp: Date(), exercise: .crunches, category: .exercise))
    return WorkoutView().modelContainer(container)
}

