//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation
import CoreData

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    private let coreDataStack = CoreDataStack.shared
    
    func createCategory(with category: TrackerCategory) {
        let categoryEntity = TrackerCategoryCoreData(context: coreDataStack.context)
        categoryEntity.categoryId = category.id
        categoryEntity.title = category.title
        categoryEntity.trackers = NSSet()

        coreDataStack.saveContext()
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let categoriesCoreDataArray = try coreDataStack.context.fetch(fetchRequest)
            let categories = categoriesCoreDataArray.compactMap { categoriesCoreData -> TrackerCategory? in
                decodingCategory(from: categoriesCoreData)
            }
            return categories
        } catch {
            print("❌ Failed to fetch categories: \(error)")
            return []
        }
    }
}

extension TrackerCategoryStore {
    private func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard
            let id = trackerCategoryCoreData.categoryId,
            let title = trackerCategoryCoreData.title,
            let trackerCoreDataArray = trackerCategoryCoreData.trackers as? [TrackerCoreData]
        else {
            return nil
        }
        
        let trackers = trackerCoreDataArray.compactMap { trackerCoreData -> Tracker? in
            Tracker.init(from: trackerCoreData)
        }
        
        return TrackerCategory(id: id, title: title, trackerList: trackers)
    }
}
