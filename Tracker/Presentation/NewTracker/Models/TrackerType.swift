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
    case editHabit
    case editEvent
    
    var paramsCellsCount: Int {
        switch self {
        case .habit, .editHabit: 2
        case .event, .editEvent: 1
        }
    }
    
    var title: String {
        switch self {
        case .habit: Constants.habit
        case .event: Constants.event
        case .editHabit: Constants.editHabit
        case .editEvent: Constants.editEvent
        }
    }
}

private extension TrackerType {
    enum Constants {
        static let habit = NSLocalizedString("newTracker.screen.habit.new", comment: "")
        static let event = NSLocalizedString("newTracker.screen.irregularEvent.new", comment: "")
        static let editHabit = NSLocalizedString("newTracker.screen.habit.edit", comment: "")
        static let editEvent = NSLocalizedString("newTracker.screen.irregularEvent.edit", comment: "")
    }
}
