//
//  TrackerRecordStoreProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 21.09.2024.
//

import Foundation

protocol TrackerRecordStoreProtocol {
    var delegate: TrackerStoreDelegate? { get set }
    func addTrackerRecord(with trackerRecord: TrackerRecord)
    func fetchAllRecords() -> [TrackerRecord]
    func deleteRecord(for trackerRecord: TrackerRecord)
}
