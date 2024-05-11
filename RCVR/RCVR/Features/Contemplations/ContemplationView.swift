//
//  ContemplationView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData
struct ContemplationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var contemplations: [Contemplation]
    @State private var showContemplationSheet: Bool = false
    
    private var notificationManager:  NotificationManager = NotificationManager()
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let cont : Contemplation = contemplations[index]
                if let notificationId = cont.notificationId {
                    notificationManager.removeNotification(id: notificationId.uuidString)
                }
                
                modelContext.delete(cont)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(contemplations) { item in
                NavigationLink("\(item.technique.rawValue) \(item.timestamp, format: Date.FormatStyle(time: .shortened))", destination: LogContemplationView(contemplation: item))
            }
            .onDelete(perform: deleteItems)
        }
        
        Button(action : {
            showContemplationSheet.toggle()
        }) {
            Label("Add New \(Category.contemplation.rawValue)", systemImage: "figure.mind.and.body")
        }
        .sheet(isPresented: $showContemplationSheet) {
            contemplationSheet(notificationManager: self.notificationManager)
        }
        .frame(width: 300, height: 50, alignment: .center)
            .background(Color.blue)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
}

struct contemplationSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var technique : Technique = .meditation
    @State var time : Date = Date()
    var notificationManager:  NotificationManager
    
    init(notificationManager:  NotificationManager){
        self.notificationManager = notificationManager
    }
    private func addItem(newItem : Contemplation) {
        withAnimation {
            modelContext.insert(newItem)
            notificationManager.scheduleNotifications(from: newItem.timestamp, id: newItem.notificationId ?? UUID(), subTitle: "Time For \(newItem.technique)")
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
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                
            }.toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {dismiss()}
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let newItem = Contemplation(timestamp: time, category: .contemplation, technique: technique)
                        addItem(newItem: newItem)
                       
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    ContemplationView()
        .modelContainer(for: Contemplation.self, inMemory: true)
}

