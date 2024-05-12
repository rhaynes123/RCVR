//
//  ContemplationsHistoryView.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import SwiftUI
import SwiftData
import Charts
struct ContemplationsHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:[SortDescriptor(\ContemplationHistory.endTime, order: .reverse)]
            , animation: .snappy) private var history: [ContemplationHistory]
    
    // MARK: Begin Private Methods
    private func getChartData(history: [ContemplationHistory]) -> [ContemplationChartData] {
        var data : [ContemplationChartData] = []
        for hist in history {
            if data.contains(where: {$0.contemplation == hist.technique.rawValue}) {
                data.first{$0.contemplation == hist.technique.rawValue}?.history.append(hist)
            } else {
                let chart : ContemplationChartData = ContemplationChartData(contemplation: hist.technique.rawValue, history: [hist])
                data.append(chart)
            }
        }
        return data
    }
    // MARK: End Private Methods
    
    var body: some View {
        VStack {
            Text("Mental Contemplations")
            let totalTime = history.reduce(0){$0 + ($1.endTime.timeIntervalSince($1.startTime))}
            let lastContemplation : ContemplationHistory?  = history.last
            let histData : [ContemplationChartData] = getChartData(history: self.history)
            Text("\(totalTime / 60 , format: .number) total minutes in contemplation as of \(lastContemplation?.endTime ?? Date(), format: Date.FormatStyle(date: .abbreviated))").font(.footnote)
            Chart(histData, id: \.contemplation)  { dat in
               
                ForEach(dat.history){ cont in
                    LineMark(
                        x: .value("Start Time", cont.startTime) ,
                        y: .value("Total Duration", cont.endTime.timeIntervalSince(cont.startTime) / 60)
                    )
                }.foregroundStyle(by: .value("Contemplation Technique", dat.contemplation))
                    .symbol(by: .value("Contemplation Technique", dat.contemplation))
            }
        }
        List(history){ contemplation in
            Text("\(contemplation.technique.rawValue) done between \(contemplation.startTime, format: Date.FormatStyle(date:.numeric, time: .shortened)) and \(contemplation.endTime, format: Date.FormatStyle(date:.numeric, time: .shortened))")
            
        }
    }
}

final class ContemplationChartData: Identifiable {
    let contemplation: String
    var history: [ContemplationHistory]
    var id: String { contemplation }
    init(contemplation: String, history: [ContemplationHistory]) {
        self.contemplation = contemplation
        self.history = history
    }
}

#Preview {
    let container = try! ModelContainer(for: ContemplationHistory.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    for _ in 0...20 {
        let contemplation = ContemplationHistory(technique: .meditation, startTime: Date(), endTime: Date().addingTimeInterval(100))
        container.mainContext.insert(contemplation)
    }
    return ContemplationsHistoryView().modelContainer(container)
}
