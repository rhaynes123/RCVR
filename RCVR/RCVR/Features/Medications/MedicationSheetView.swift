//
//  MedicationSheetView.swift
//  RCVR
//
//  Created by richard Haynes on 5/18/24.
//

import SwiftUI
import SwiftData

struct medicationSheet : View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var dosage : Int = 1
    @State var title : String = ""
    @State var adminstration : Adminstration = .pill
    @State var time : Date = Date()
    @State private var isOneTime : Bool = false
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
                Section{
                    Toggle("One Time", isOn: $isOneTime)
                } footer: {
                    Text("Choosing one time will prevent adding item to your list and a notification won't be made")
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {dismiss()}
                        .buttonStyle(.bordered)
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    let medication = Medication(timestamp: time, administration: adminstration, title: title, category: .medication, dose: dosage)
                    if isOneTime {
                        NavigationLink("Log"){
                            LogMedicationView(medication: medication)
                        }
                    }
                    else {
                        Button("Save") {
                            addItem(newItem: medication)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(notCompleted)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Medication.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return medicationSheet(notificationManager: NotificationManager()).modelContainer(container)
}

