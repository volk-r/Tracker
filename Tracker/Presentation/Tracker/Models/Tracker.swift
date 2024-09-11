//
//  Tracker.swift
//  Tracker
//
//  Created by Roman Romanov on 01.09.2024.
//

import UIKit

struct Tracker {
    let id = UUID()
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
    
    struct NewTrackerData {
        var name: String? = nil
        var color: UIColor? = nil
        var emoji: String? = nil
        var schedule: [WeekDay]? = nil
    }
}
