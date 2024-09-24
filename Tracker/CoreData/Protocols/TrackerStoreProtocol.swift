//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation

protocol TrackerStoreProtocol {
    var numberOfTrackers: Int { get }
    var numberOfSections: Int { get }
    func fetchTrackers() -> [Tracker]
    func addTracker(with tracker: Tracker)
    func numberOfRowsInSection(_ section: Int) -> Int
}
