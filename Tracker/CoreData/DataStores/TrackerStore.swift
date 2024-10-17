//
//  TrackerStore.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation
import CoreData

final class TrackerStore: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: TrackerStoreDelegate?
    
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
            sectionNameKeyPath: "category.title",
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
            let trackers = try trackerCoreDataArray
                .compactMap { trackerCoreData -> Tracker in
                    guard let tracker = Tracker.init(from: trackerCoreData) else {
                        throw StoreErrors.decodeDataError
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
        trackerEntity.colorHEX = UIColorMarshalling.serialize(color: tracker.color)
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = tracker.schedule as? NSArray
        trackerEntity.name = tracker.name
        trackerEntity.category = categoryCoreData

        coreDataStack.saveContext()
    }
    
    func deleteTracker(_ tracker: Tracker) {
        guard let trackerToDelete = getTrackerCoreData(by: tracker.id) else {
            return
        }
        coreDataStack.context.delete(trackerToDelete)
        coreDataStack.saveContext()
    }
    
    func getTrackerCoreData(by id: UUID) -> TrackerCoreData? {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId), id.uuidString
        )
        do {
            try fetchedResultsController.performFetch()
            guard let tracker = fetchedResultsController.fetchedObjects?.first else {
                throw StoreErrors.fetchTrackerError
            }
            fetchedResultsController.fetchRequest.predicate = nil
            try fetchedResultsController.performFetch()
            
            return tracker
        } catch {
            print("❌ Failed to fetch tracker by UUID: \(error)")
            return nil
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didTrackersUpdate()
    }
}
