//
//  TrackerType.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import Foundation

enum TrackerType {
    case habit
    case event
    
    var paramsCellsCount: Int {
        switch self {
            case .habit: 2
            case .event: 1
        }
    }
    
    var title: String {
        switch self {
            case .habit: Constants.habit
            case .event: Constants.event
        }
    }
}

private extension TrackerType {
    enum Constants {
        static let habit = NSLocalizedString("habit.new", comment: "")
        static let event = NSLocalizedString("irregularEvent.new", comment: "")
    }
}
