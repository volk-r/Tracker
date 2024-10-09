//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation
import CoreData

final class TrackerRecordStore: NSObject, TrackerRecordStoreProtocol {
    
    // MARK: - Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    private let coreDataStack = CoreDataStack.shared
    private let trackerStore = TrackerStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.createdAt, ascending: true),
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultsController
    }()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        try? fetchedResultsController.performFetch()
        fetchedResultsController.delegate = self
    }
    
    // MARK: - addTrackerRecord
    
    func addTrackerRecord(with trackerRecord: TrackerRecord) {
        let trackerRecordEntity = TrackerRecordCoreData(context: coreDataStack.context)
        trackerRecordEntity.recordId = trackerRecord.id
        trackerRecordEntity.trackerId = trackerRecord.trackerId
        trackerRecordEntity.createdAt = trackerRecord.date
        
        let trackerCoreData = trackerStore.getTrackerCoreData(by: trackerRecord.trackerId)
        trackerRecordEntity.tracker = trackerCoreData
        
        coreDataStack.saveContext()
        print("✅ Record added: \(trackerRecord)")
    }
    
    // MARK: - fetchAllRecords
    
    func fetchAllRecords() -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            let trackerRecordsCoreDataArray = try coreDataStack.context.fetch(fetchRequest)
            let trackerRecords = trackerRecordsCoreDataArray
                .compactMap { trackerRecordsCoreData -> TrackerRecord? in
                    TrackerRecord(from: trackerRecordsCoreData)
                }
            return trackerRecords
        } catch {
            print("❌ Failed to fetch tracker records: \(error)")
            return []
        }
    }
    
    // MARK: - deleteRecord
    
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
                coreDataStack.saveContext()
                print("✅ Record deleted: \(trackerRecord)")
            } else {
                print("❕ Record not found: \(trackerRecord)")
            }
        } catch {
            print("❌ Failed to delete record: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didTrackersUpdate()
    }
}
