//
//  Activity.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import Foundation
protocol Activity{
    var category: Category { get set }
}

enum Category: String, CaseIterable, Codable {
    case exercise = "Exercise"
    case medication = "Medication"
    case contemplation = "Contemplation"
}


