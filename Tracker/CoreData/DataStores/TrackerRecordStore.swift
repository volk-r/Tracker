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
        trackerRecordEntity.trackerId = trackerRecord.trackerId
        trackerRecordEntity.createdAt = trackerRecord.date
        
        coreDataStack.saveContext()
    }
    
    func fetchAllRecords() -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            let trackerRecordsCoreDataArray = try coreDataStack.context.fetch(fetchRequest)
            let trackerRecords = trackerRecordsCoreDataArray.compactMap { trackerRecordsCoreData ->
                TrackerRecord? in
                return TrackerRecord(from: trackerRecordsCoreData)
            }
            return trackerRecords
        } catch {
            print("❌ Failed to fetch tracker records: \(error)")
            return []
        }
    }
    
    func deleteRecord(for trackerRecord: TrackerRecord) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            #keyPath(TrackerRecordCoreData.trackerId),
            trackerRecord.trackerId as CVarArg,
            #keyPath(TrackerRecordCoreData.createdAt),
            trackerRecord.date as CVarArg
        )
        do {
            let results = try coreDataStack.context.fetch(fetchRequest)
            if let recordToDelete = results.first {
                coreDataStack.context.delete(recordToDelete)
                try coreDataStack.context.save()
                print("✅ Record deleted: \(trackerRecord)")
            } else {
                print("❕ Record not found: \(trackerRecord)")
            }
        } catch {
            print("❌ Failed to delete record: \(error)")
        }
    }
}
