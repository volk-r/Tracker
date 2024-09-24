//
//  Tracker.swift
//  Tracker
//
//  Created by Roman Romanov on 01.09.2024.
//

import UIKit

struct Tracker: Hashable {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
    
    struct NewTrackerData {
        var id: UUID? = nil
        var name: String? = nil
        var color: UIColor? = nil
        var emoji: String? = nil
        var schedule: [WeekDay]? = nil
    }
}

extension Tracker {
    init?(from trackerEntity: TrackerCoreData) {
        guard
            let id = trackerEntity.trackerId,
            let name = trackerEntity.name,
            let emoji = trackerEntity.emoji,
            let color = trackerEntity.color as? UIColor
        else {
            return nil
        }
        
        let schedule = trackerEntity.schedule as? [WeekDay]
        
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
