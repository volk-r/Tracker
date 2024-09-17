//
//  WeekDay.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable, Comparable, Codable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
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
    
    static func < (lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
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
    
    static func getScheduleString(from schedule: [WeekDay]?) -> String? {
        guard let schedule else { return nil }
        
        if schedule.count == WeekDay.allCases.count {
            return "Каждый день"
        }
        
        let shortNameString: [String] = schedule.map { $0.shortName }
        
        return shortNameString.joined(separator: ", ")
    }
}
