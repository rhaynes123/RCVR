//
//  RCVRApp.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData

@main
struct RCVRApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Workout.self,
            WorkoutHistory.self,
            Medication.self,
            MedicationHistory.self,
            Contemplation.self,
            ContemplationHistory.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
