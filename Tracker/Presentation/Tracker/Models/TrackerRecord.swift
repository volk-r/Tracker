//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Roman Romanov on 01.09.2024.
//

import Foundation

struct TrackerRecord: Hashable {
    let id = UUID()
    let trackerId: UUID
    let date: Date
    
    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}
