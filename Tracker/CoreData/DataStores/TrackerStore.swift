//
//  TrackerStore.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation
import CoreData

final class TrackerStore: NSObject {
    private let coreDataStack = CoreDataStack.shared
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
}

extension TrackerStore {
    // MARK: - TrackerStoreError
    enum TrackerStoreError: Error {
        case decodeDataError
    }
}

// MARK: - TrackerStoreProtocol
extension TrackerStore: TrackerStoreProtocol {
    var numberOfTrackers: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func fetchTrackers() -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        do {
            let trackerCoreDataArray = try coreDataStack.context.fetch(fetchRequest)
            let trackers = try trackerCoreDataArray.compactMap { trackerCoreData -> Tracker in
                guard let tracker = Tracker.init(from: trackerCoreData) else {
                    throw TrackerStoreError.decodeDataError
                }
                return tracker
            }
            
            return trackers
        } catch {
            print("❌ Failed to fetch trackers: \(error)")
            return []
        }
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        guard let categoryCoreData = trackerCategoryStore.getCategoryById(category.id) else {
            return
        }
        
        let trackerEntity = TrackerCoreData(context: coreDataStack.context)
        trackerEntity.trackerId = tracker.id
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = tracker.schedule as? NSArray
        trackerEntity.name = tracker.name
        trackerEntity.category = categoryCoreData
        
        coreDataStack.saveContext()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    
}
