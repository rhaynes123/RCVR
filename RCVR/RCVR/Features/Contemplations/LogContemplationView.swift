//
//  LogContemplationView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData


struct LogContemplationView : View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var presentAlert: Bool = false
    @State private var startTime : Date = Date()
    @State private var endTime : Date = Date()
    var canLog : Bool {
        return endTime < startTime
    }
    var contemplation : Contemplation
    init(contemplation: Contemplation) {
        self.contemplation = contemplation
    }
    private func log(entry: ContemplationHistory){
        if canLog {
            return
        }
        modelContext.insert(entry)
        
    }
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Name: \(contemplation.technique.rawValue)")
                    Text("Scheduled Contemplation Time at \(contemplation.timestamp, format: Date.FormatStyle( time: .shortened))")
                    
                    DatePicker("Start Time", selection: $startTime)
                    DatePicker("End Time", selection: $endTime)
                } footer: {
                    Text("End can not be before start")
                        .foregroundStyle(.gray)
                }
                Button("Log"){
                    let entry = ContemplationHistory(technique: contemplation.technique, startTime: startTime, endTime: endTime)
                    log(entry: entry)
                    if !canLog {
                        presentAlert.toggle()
                    }
                }
                .alert("WooHoo!", isPresented: $presentAlert){
                    Button("Completed", role: .cancel){
                        modelContext.insert( Point(category: Category.contemplation, timestamp: Date()))
                        dismiss()
                    }
                } message: {
                    Text("You have recovered +\(Category.contemplation.points) points!")
                }.disabled(canLog)
            }
        }
    }
    
}

#Preview {
    let schema = Schema([
        ContemplationHistory.self,
        Point.self
    ])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let contemplation = Contemplation(timestamp: Date(), category: .contemplation, technique: .meditation)
    return LogContemplationView(contemplation: contemplation).modelContainer(container)
}

