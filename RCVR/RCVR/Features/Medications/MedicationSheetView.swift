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
    @Environment(NotificationManager.self) private var notificationManager: NotificationManager
    @State var dosage : Int = 1
    @State var title : String = ""
    @State var adminstration : Administration = .pill
    @State var time : Date = Date()
    @State private var isOneTime : Bool = false
    @State private var hasErrors : Bool = false
    @FocusState var isFocused: Bool
    
    
    private func IsFormInComplete()-> Bool {
        if self.title.isEmpty || self.dosage <= 0 {
            hasErrors.toggle()
            return true
        }
        return false
    }
    
    
    private func addItem(newItem : Medication) {
        withAnimation {
            if IsFormInComplete() {
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
                        .foregroundStyle(hasErrors ? .red : .secondary)
                }
                
                Picker("Choose Administration", selection: $adminstration){
                    ForEach(Administration.allCases, id: \.self) {admin in
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
                        .foregroundStyle(hasErrors ? .red : .secondary)
                }
                
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                Section{
                    Toggle("One Time", isOn: $isOneTime)
                        .accessibilityIdentifier("isOneTime")
                } footer: {
                    Text("Choosing one time will prevent adding item to your list and a notification won't be made")
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(isOneTime ? "Done":"Cancel", role: .cancel) {dismiss()}
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("doneOrCancel")
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
                    }
                    
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Medication.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let notificationManager =  NotificationManager()
    return medicationSheet()
        .environment(notificationManager)
        .modelContainer(container)
}

