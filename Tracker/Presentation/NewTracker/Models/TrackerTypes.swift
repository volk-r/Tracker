//
//  TrackerTypes.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import Foundation

enum TrackerTypes: String {
    case habit = "Новая привычка"
    case event = "Новое нерегулярное событие"
    
    var paramsCellsCount: Int {
        switch self {
            case .habit: 2
            case .event: 1
        }
    }
}
