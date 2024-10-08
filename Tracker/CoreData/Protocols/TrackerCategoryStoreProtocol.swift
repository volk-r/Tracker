//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    func createCategory(with category: TrackerCategory)
    func updateCategory(with data: TrackerCategory)
    func fetchAllCategories() -> [TrackerCategory]
    func getCategoryById(_ id: UUID) -> TrackerCategoryCoreData?
    func deleteCategory(_ category: TrackerCategory)
}
