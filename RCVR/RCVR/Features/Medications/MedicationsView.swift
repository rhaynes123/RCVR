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
    @Query private var medications: [Medication]
    @State private var showSheet: Bool = false
    
    private var notificationManager:  NotificationManager = NotificationManager()
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
            medicationSheet(notificationManager: self.notificationManager)
        }
        .frame(width: 300, height: 50, alignment: .center)
            .background(Color.yellow)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
}

struct medicationSheet : View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var dosage : Int = 1
    @State var title : String = ""
    @State var adminstration : Adminstration = .pill
    @State var time : Date = Date()
    var notificationManager:  NotificationManager
    
    init(notificationManager:  NotificationManager){
        self.notificationManager = notificationManager
    }
    
    var notCompleted : Bool {
        return self.title.isEmpty || self.dosage <= 0
    }
    
    
    private func addItem(newItem : Medication) {
        withAnimation {
            if notCompleted {
                print("Title and dosage are required")
                return
            }
            
            modelContext.insert(newItem)
            if let notificationId = newItem.notificationId {
                
                notificationManager.scheduleNotifications(from: newItem.timestamp, id: notificationId, subTitle: "Time For (\(newItem.dose)) (\(newItem.administration)) \(newItem.title)")
            }
            
            dismiss()
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Medication Name", text: $title)
                } footer: {
                    Text("Medication Name Is Required")
                        .foregroundStyle(.red)
                }
                
                Picker("Choose Administration", selection: $adminstration){
                    ForEach(Adminstration.allCases, id: \.self) {admin in
                        Text(admin.rawValue)
                        
                    }
                }
                
                Section {
                    TextField("Dose", value: $dosage, format: .number)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Dosage")
                } footer: {
                    Text("Dosage can not be zero")
                        .foregroundStyle(.red)
                }
                
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {dismiss()}
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    Button("Save") {
                        let medication = Medication(timestamp: time, administration: adminstration, title: title, category: .medication, dose: dosage)
                        addItem(newItem: medication)
                        
                    }
                    .disabled(notCompleted)
                }
            }
        }
    }
}



#Preview {
    let container = try! ModelContainer(for: Medication.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(Medication(timestamp: Date(), administration: .pill, title: "Asprin", category: .medication, dose: 2))
    return MedicationsView().modelContainer(container)
}
