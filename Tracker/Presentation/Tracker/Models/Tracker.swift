//
//  Tracker.swift
//  Tracker
//
//  Created by Roman Romanov on 01.09.2024.
//

import Foundation

struct Tracker {
    let id = UUID()
    let name: String
    let color: String
    let emoji: String
    let schedule: [String: Bool]
}
