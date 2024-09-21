//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Roman Romanov on 01.09.2024.
//

import Foundation

struct TrackerCategory {
    let id = UUID()
    let title: String
    let trackerList: [Tracker]
}
