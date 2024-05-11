//
//  MainView.swift
//  RCVR
//
//  Created by richard Haynes on 4/7/24.
//
import SwiftUI
struct MainView: View {
    private var notificationManager: NotificationManager = NotificationManager()
    var body: some View {
        NavigationSplitView {
            Image("logo").resizable().frame(width: 50, height: 50)
            Form {
                
                Text("My Activities and Trends").font(.title)
                
                NavigationLink(destination: WorkoutHistoryView()){
                    Label("\(Category.exercise.rawValue) Trends", systemImage: "figure.run")
                }
                NavigationLink(destination: MedicationHistoryView()){
                    Label("\(Category.medication.rawValue) Trends", systemImage: "pills.circle")
                }
                NavigationLink(destination: ContemplationsHistoryView()){
                    Label("\(Category.contemplation.rawValue) Trends", systemImage: "figure.mind.and.body")
                }
                
                ForEach(Category.allCases, id: \.rawValue) { cat in
                    Section {
                        switch cat {
                        case .exercise:
                            WorkoutView()
                        case .medication:
                            MedicationsView()
                        case .contemplation:
                            ContemplationView()
                        }
                    } header: {
                        Text(cat.rawValue)
                    }
                }
            }
        } detail: {
            Text("Select an activity")
        }.toolbar(.hidden)
            .onAppear{
                notificationManager.requestNotificationAuthorization()
                
            }
            .task {
                await notificationManager.resetBadge()
            }
        
    }

   
}

#Preview {
    MainView()
}

    
