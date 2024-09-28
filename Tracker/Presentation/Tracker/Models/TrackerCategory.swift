//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Roman Romanov on 01.09.2024.
//

import Foundation

struct TrackerCategory: Hashable {
    let id: UUID
    let title: String
    let trackerList: [Tracker]
}

extension TrackerCategory {
    init?(from categoryCoreData: TrackerCategoryCoreData) {
        guard let title = categoryCoreData.title,
              let id = categoryCoreData.categoryId
        else {
            return nil
        }
        
        let trackerList = categoryCoreData.trackers as? Set<Tracker> ?? []
        
        self.title = title
        self.id = id
        self.trackerList = Array(trackerList)
    }
}
