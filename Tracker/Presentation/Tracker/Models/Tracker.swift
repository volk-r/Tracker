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
        let id: UUID?
        let name: String?
        let color: UIColor?
        let emoji: String?
        let schedule: [WeekDay]?
        
        init(
            id: UUID? = nil,
            name: String? = nil,
            color: UIColor? = nil,
            emoji: String? = nil,
            schedule: [WeekDay]? = nil
        ) {
            self.id = id
            self.name = name
            self.color = color
            self.emoji = emoji
            self.schedule = schedule
        }
    }
}

extension Tracker {
    init?(from trackerEntity: TrackerCoreData) {
        guard
            let id = trackerEntity.trackerId,
            let name = trackerEntity.name,
            let emoji = trackerEntity.emoji,
            let colorHEX = trackerEntity.colorHEX
        else {
            return nil
        }
        
        let color = UIColorMarshalling.deserialize(hexString: colorHEX)
        let schedule = trackerEntity.schedule as? [WeekDay]
        
        self.id = id
        self.name = name
        self.color = color ?? UIColor()
        self.emoji = emoji
        self.schedule = schedule
    }
}
