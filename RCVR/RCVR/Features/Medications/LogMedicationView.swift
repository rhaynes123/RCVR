//
//  LogMedicationView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData
struct LogMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var actualTime : Date = Date()
    @State private var presentAlert : Bool = false
    var medication : Medication
    
    init(medication: Medication) {
        self.medication = medication
    }
    private func log(entry: MedicationHistory){
        modelContext.insert(entry)
    }
    var body: some View {
        VStack {
            Form {
                Text("Name: \(medication.title)")
                Text("Dosage: \(medication.dose)  \(medication.administration.rawValue)(s)")
                Text("Dosage Time at \(medication.timestamp, format: Date.FormatStyle( time: .shortened))")
                
                DatePicker("Actual Time", selection: $actualTime)
                Button("Log"){
                    let entry = MedicationHistory(administration: medication.administration, startTime: actualTime, dose: medication.dose, title: medication.title)
                    log(entry: entry)
                    presentAlert.toggle()
                }.alert("WooHoo!", isPresented: $presentAlert){
                    Button("Completed", role: .cancel){
                        modelContext.insert( Point(category: Category.medication, timestamp: Date()))
                        dismiss()
                    }
                } message: {
                    Text("You have recovered +\(self.medication.category.points) points!")
                }
            }
        }
    }
}

#Preview {
    let schema = Schema([
        MedicationHistory.self,
        Point.self
    ])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let medication = Medication(timestamp: Date(), administration: .injection, title: "Asprin", category: .medication, dose: 2)
    return LogMedicationView(medication: medication).modelContainer(container)
}
