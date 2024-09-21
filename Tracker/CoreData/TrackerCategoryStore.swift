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

        coreDataStack.saveContext()
    }
}
