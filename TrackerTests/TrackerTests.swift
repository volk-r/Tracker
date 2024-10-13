//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Roman Romanov on 13.10.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testMyViewController() {
        let vc = TrackerViewController()
        
        assertSnapshot(of: vc, as: .image)
    }
    
}
