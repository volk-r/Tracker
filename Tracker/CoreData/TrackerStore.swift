//
//  TrackerStore.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation
import CoreData

final class TrackerStore: TrackerStoreProtocol {
    private let coreDataStack = CoreDataStack.shared
    
    func createTracker(with tracker: Tracker) {
        let trackerEntity = TrackerCoreData(context: coreDataStack.context)
        trackerEntity.trackerId = tracker.id
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = tracker.schedule as NSArray?
        trackerEntity.name = tracker.name
        
        coreDataStack.saveContext()
    }
}
