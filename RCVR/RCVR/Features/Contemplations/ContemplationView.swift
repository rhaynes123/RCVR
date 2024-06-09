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
    @Environment(NotificationManager.self) private var notificationManager: NotificationManager
    @Query private var contemplations: [Contemplation]
    @State private var showContemplationSheet: Bool = false
    
    
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
            contemplationSheet()
        }
        .frame(width: 300, height: 50, alignment: .center)
            .background(Color.blue)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
}


#Preview {
    let notificationManager = NotificationManager()
    return ContemplationView()
        .environment(notificationManager)
        .modelContainer(for: Contemplation.self, inMemory: true)
}

