//
//  WeekDays.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import Foundation

enum WeekDays: Int, CaseIterable {
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
    
    static func getDayName(_ number: Int) -> String {
        switch number {
        case self.monday.rawValue: return self.monday.description
        case self.tuesday.rawValue: return self.tuesday.description
        case self.wednesday.rawValue: return self.wednesday.description
        case self.thursday.rawValue: return self.thursday.description
        case self.friday.rawValue: return self.friday.description
        case self.saturday.rawValue: return self.saturday.description
        case self.sunday.rawValue: return self.sunday.description
        default: return "Unknown"
        }
    }
    
    var description: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}
