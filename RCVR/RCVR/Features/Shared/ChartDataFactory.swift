//
//  ChartHelper.swift
//  RCVR
//
//  Created by richard Haynes on 5/25/24.
//

import Foundation
struct ChartDataFactory {
    static func create<T: Chartable>(history: [T]) -> [ChartData] {
        var data : [String : ChartData] = [:]
        
        for medicalData in history {
            
            let chartId : String = medicalData.getChartId().lowercased()
            
            if let foundData = data[chartId]{
                foundData.history.append(medicalData as T)
            } else {
                let chart : ChartData = ChartData(id: medicalData.getChartId(), history: [medicalData as T])
                data[chartId] = chart
            }
        }
        return Array(data.values)
    }
}


final class ChartData: Identifiable {
    var history: [any Chartable]
    var id: String
    init(id: String, history: [any Chartable]) {
        self.id = id
        self.history = history
    }
}
