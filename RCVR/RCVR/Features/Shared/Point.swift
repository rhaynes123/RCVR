//
//  Point.swift
//  RCVR
//
//  Created by richard Haynes on 8/31/24.
//

import Foundation
import SwiftData

@Model
final class Point {
    var category: Category
    var amount: Int
    var timestamp: Date
    init(category: Category, timestamp: Date) {
        self.category = category
        self.timestamp = timestamp
        self.amount = category.points
    }
    
}
