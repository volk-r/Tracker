//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation

protocol TrackerStoreProtocol {
    var delegate: TrackerStoreDelegate? { get set }
    var numberOfTrackers: Int { get }
    var numberOfSections: Int { get }
    func fetchTrackers() -> [Tracker]
    func addTracker(_ tracker: Tracker, to category: TrackerCategory)
    func updateTracker(_ tracker: Tracker, from category: TrackerCategory)
    func deleteTracker(_ tracker: Tracker)
    func getTrackerCoreData(by id: UUID) -> TrackerCoreData?
    func numberOfRowsInSection(_ section: Int) -> Int
}
