//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation
import CoreData

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    // MARK: PROPERTIES
    private let coreDataStack = CoreDataStack.shared
    
    // MARK: FUNCTIONS
    func createCategory(with category: TrackerCategory) {
        let categoryEntity = TrackerCategoryCoreData(context: coreDataStack.context)
        categoryEntity.categoryId = category.id
        categoryEntity.title = category.title
        categoryEntity.trackers = NSSet()

        coreDataStack.saveContext()
    }
    
    func updateCategory(with data: TrackerCategory) {
        let category = getCategoryById(data.id)
        category?.title = data.title
        coreDataStack.saveContext()
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        let categoryToDelete = getCategoryById(category.id)
        
        guard let categoryToDelete, let categoryId = categoryToDelete.categoryId else {
            print("❌ Failed to fetch category: \(category)")
            return
        }

        // TODO: remove all records
        // TODO: remove all trackers
        
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.categoryId),
            categoryId.uuidString
        )

        do {
            let results = try coreDataStack.context.fetch(fetchRequest)
            if let recordToDelete = results.first {
                coreDataStack.context.delete(recordToDelete)
                coreDataStack.saveContext()
                print("✅ Category deleted: \(category)")
            } else {
                print("❕ Category not found: \(category)")
            }
        } catch {
            print("❌ Failed to delete category: \(error)")
        }
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let categoriesCoreDataArray = try coreDataStack.context.fetch(fetchRequest)
            let categories = categoriesCoreDataArray
                .compactMap { categoriesCoreData -> TrackerCategory? in
                    decodingCategory(from: categoriesCoreData)
                }
            return categories
        } catch {
            print("❌ Failed to fetch categories: \(error)")
            return []
        }
    }
    
    func getCategoryById(_ id: UUID) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.categoryId),
            id.uuidString
        )
        request.fetchLimit = 1
        
        do {
            let category = try coreDataStack.context.fetch(request)
            return category.first
        } catch {
            print("❌ Failed to find category by ID: \(error)")
            return nil
        }
    }
}

extension TrackerCategoryStore {
    // MARK: decodingCategory
    private func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard
            let id = trackerCategoryCoreData.categoryId,
            let title = trackerCategoryCoreData.title,
            let trackerCoreDataSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData>
        else {
            return nil
        }
        
        let trackers = trackerCoreDataSet
            .compactMap { trackerCoreData -> Tracker? in
                Tracker.init(from: trackerCoreData)
            }
        
        return TrackerCategory(id: id, title: title, trackerList: trackers)
    }
}
