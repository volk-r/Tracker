//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation
import CoreData

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let coreDataStack = CoreDataStack.shared
    
    func addTrackerRecord(with trackerRecord: TrackerRecord) {
        let trackerRecordEntity = TrackerRecordCoreData(context: coreDataStack.context)
        trackerRecordEntity.recordId = trackerRecord.id
        trackerRecordEntity.createdAt = trackerRecord.date
        
        coreDataStack.saveContext()
    }
}
