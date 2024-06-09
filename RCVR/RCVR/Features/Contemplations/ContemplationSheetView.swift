//
//  ContemplationSheetView.swift
//  RCVR
//
//  Created by richard Haynes on 5/18/24.
//

import SwiftUI
import SwiftData
struct contemplationSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(NotificationManager.self) private var notificationManager: NotificationManager
    @State var technique : Technique = .meditation
    @State var time : Date = Date()
    @State private var isOneTime : Bool = false
    
    private func addItem(newItem : Contemplation) {
        withAnimation {
            modelContext.insert(newItem)
            if let notificationId = newItem.notificationId {
                notificationManager.scheduleNotifications(from: newItem.timestamp, id: notificationId, subTitle: "Time For \(newItem.technique.rawValue)")
            }
            dismiss()
        }
    }
    var body: some View {
        NavigationStack {
            Form {
                Picker("Technique", selection: $technique){
                    ForEach(Technique.allCases, id: \.self) {technique in
                        Text(technique.rawValue)
                        
                    }
                }
                .accessibilityIdentifier("techniquePicker")
                
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .accessibilityIdentifier("time")
                
                Section{
                    Toggle("OneTime", isOn: $isOneTime)
                        .accessibilityIdentifier("isOneTime")
                } footer: {
                    Text("Choosing one time will prevent adding item to your list and a notification won't be made")
                }
                
            }.toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(isOneTime ? "Done":"Cancel", role: .cancel) {dismiss()}
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("doneOrCancel")
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    let newItem = Contemplation(timestamp: time, category: .contemplation, technique: technique)
                    if isOneTime {
                        NavigationLink("Log"){
                            LogContemplationView(contemplation: newItem)
                        }.buttonStyle(.borderedProminent)
                    }
                    else {
                        Button("Save") {
                            
                            addItem(newItem: newItem)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Contemplation.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let notificationManager = NotificationManager()
    return contemplationSheet()
        .environment(notificationManager)
        .modelContainer(container)
}
