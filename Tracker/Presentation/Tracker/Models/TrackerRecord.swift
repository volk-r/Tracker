//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Roman Romanov on 01.09.2024.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let trackerId: UUID
    let date: Date
}

extension TrackerRecord {
    init?(from trackerRecordEntity: TrackerRecordCoreData) {
        guard let recordId = trackerRecordEntity.recordId,
              let trackerId = trackerRecordEntity.trackerId,
              let date = trackerRecordEntity.createdAt
        else {
            return nil
        }
        
        self.id = recordId
        self.trackerId = trackerId
        self.date = date
    }
}
