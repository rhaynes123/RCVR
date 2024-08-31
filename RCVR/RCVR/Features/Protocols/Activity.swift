//
//  Activity.swift
//  RCVR
//
//  Created by richard Haynes on 4/6/24.
//

import Foundation
protocol Activity {
    var category: Category { get set }
    var notificationId : UUID? {get set}
}

enum Category: String, CaseIterable, Codable {
    case exercise = "Exercise"
    case medication = "Medication"
    case contemplation = "Contemplation"
    
    var points : Int  {
        switch self {
        case .contemplation:
            return 1
        case .medication:
            return 3
        case .exercise:
            return 5
        }
    }
}


