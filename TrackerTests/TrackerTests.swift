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
    func testViewController() {
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)))
    }
    
    func testViewCOntrollerDarkTheme() {
        let vc = TrackerViewController()
        
        assertSnapshot(of: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)))
    }
    
}
