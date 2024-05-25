//
//  MedicationHistoryView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData
import Charts
struct MedicationHistoryView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort:[SortDescriptor(\MedicationHistory.dosageTime, order: .reverse)]
           , animation: .snappy)
    private var history: [MedicationHistory]
    
    // MARK: Begin Private Methods
    
    // MARK: End Private Methods
    
    var body: some View {
        VStack {
            Text("Medication History")
            let totalDoses =  history.reduce(0){$0 + ($1.dose)}
            let lastMedication : MedicationHistory?  = history.last
            let medicalData : [MedicalChartData] = ChartHelper.getChartData(history: self.history)
            Text("\(totalDoses, format: .number) total treatments as of \(lastMedication?.dosageTime ?? Date(), format: Date.FormatStyle(date: .abbreviated))")
                .font(.footnote)
            Chart(medicalData, id: \.medication)  { dat in
               
                ForEach(dat.history){ cont in
                    LineMark(
                        x: .value("Medication", cont.dosageTime) ,
                        y: .value("Dose", cont.dose)
                    )
                    
                }.foregroundStyle(by: .value("Medication", dat.medication))
                .symbol(by: .value("Medication", dat.medication))
            }
        }
        List(history){ med in
            Text("\(med.dose) \(med.administration.rawValue)(s) of \(med.title) taken at \(med.dosageTime, format: Date.FormatStyle(date:.numeric, time: .shortened))")
        }
    }
}



#Preview {
    let container = try! ModelContainer(for: MedicationHistory.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    for _ in 0...10 {
        let history = MedicationHistory(administration: .pill, startTime: Date().addingTimeInterval(-10000), dose: 2, title: "Oxicodone")
        container.mainContext.insert(history)
    }
    for _ in 0...5 {
        let history = MedicationHistory(administration: .injection, startTime: Date(), dose: 2, title: "Steriods")
        container.mainContext.insert(history)
    }
    return MedicationHistoryView().modelContainer(container)
}


