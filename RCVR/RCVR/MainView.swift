//
//  MainView.swift
//  RCVR
//
//  Created by richard Haynes on 4/7/24.
//
import SwiftUI
import SwiftData
struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:[SortDescriptor(\Point.timestamp, order: .reverse)]
            , animation: .snappy) private var points: [Point]
    @State private var viewCategory : Category = .exercise
    @Environment(NotificationManager.self) private var notificationManager: NotificationManager
    var body: some View {
        NavigationSplitView {
            Image("logo")
                .resizable()
                .frame(width: 50, height: 50)
            Form {
                HStack {
                    let totalPoints : Int = points.reduce(0){$0 + $1.amount}
                    Image(systemName: "cross.circle").foregroundColor(.red)
                    Text(" Total Recovered Points: \(totalPoints)")
                }
                Text("My Activities and Trends")
                    .font(.title)
                
                NavigationLink(destination: WorkoutHistoryView()){
                    Label("\(Category.exercise.rawValue) Trends", systemImage: "figure.run")
                }
                NavigationLink(destination: MedicationHistoryView()){
                    Label("\(Category.medication.rawValue) Trends", systemImage: "pills.circle")
                }
                NavigationLink(destination: ContemplationsHistoryView()){
                    Label("\(Category.contemplation.rawValue) Trends", systemImage: "figure.mind.and.body")
                }
                
                Picker("Category", selection: $viewCategory){
                    ForEach(Category.allCases, id: \.self){
                        Text($0.rawValue)
                    }
                }.pickerStyle(.segmented)
                
                Section {
                    switch self.viewCategory {
                    case .exercise:
                        WorkoutView()
                    case .medication:
                        MedicationsView()
                    case .contemplation:
                        ContemplationView()
                    }
                } header: {
                    Text(viewCategory.rawValue)
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
    let notificationManager: NotificationManager = NotificationManager()
    return MainView().environment(notificationManager)
}

    
