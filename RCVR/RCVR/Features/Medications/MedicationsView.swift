//
//  MedicationsView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//


import SwiftUI
import SwiftData
struct MedicationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(NotificationManager.self) private var notificationManager: NotificationManager
    @Query private var medications: [Medication]
    @State private var showSheet: Bool = false
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let med : Medication = medications[index]
                if let notificationId = med.notificationId {
                    notificationManager.removeNotification(id: notificationId.uuidString)
                }
                modelContext.delete(med)
                
            }
        }
    }
    
    
    var body: some View {
        List {
            ForEach(medications) { item in
                NavigationLink("\(item.title) \(item.timestamp, format: Date.FormatStyle(time: .shortened))", destination: LogMedicationView(medication: item))
            }
            .onDelete(perform: deleteItems)
        }
        
        Button(action : {
            showSheet.toggle()
        }) {
            Label("Add New \(Category.medication.rawValue)", systemImage: "pills.circle")
        }
        .sheet(isPresented: $showSheet) {
            medicationSheet()
        }
        .frame(width: 300, height: 50, alignment: .center)
            .background(Color.yellow)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
}

#Preview {
    let container = try! ModelContainer(for: Medication.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(Medication(timestamp: Date(), administration: .pill, title: "Asprin", category: .medication, dose: 2))
    let notificationManager: NotificationManager = NotificationManager()
    return MedicationsView()
        .environment(notificationManager)
        .modelContainer(container)
}
