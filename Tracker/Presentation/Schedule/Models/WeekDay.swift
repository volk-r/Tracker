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
        case .monday: return Constants.monday
        case .tuesday: return Constants.tuesday
        case .wednesday: return Constants.wednesday
        case .thursday: return Constants.thursday
        case .friday: return Constants.friday
        case .saturday: return Constants.saturday
        case .sunday: return Constants.sunday
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return Constants.mondayShort
        case .tuesday: return Constants.tuesdayShort
        case .wednesday: return Constants.wednesdayShort
        case .thursday: return Constants.thursdayShort
        case .friday: return Constants.fridayShort
        case .saturday: return Constants.saturdayShort
        case .sunday: return Constants.sundayShort
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
        default: return Constants.unknownMessage
        }
    }
    
    static func getScheduleString(from schedule: [WeekDay]?) -> String? {
        guard let schedule else { return nil }
        
        if schedule.count == WeekDay.allCases.count {
            return Constants.everyDay
        }
        
        let shortNameString: [String] = schedule.map { $0.shortName }
        
        return shortNameString.joined(separator: ", ")
    }
}

// MARK: - Constants

private extension WeekDay {
    enum Constants {
        static let monday = NSLocalizedString("monday", comment: "")
        static let tuesday = NSLocalizedString("tuesday", comment: "")
        static let wednesday = NSLocalizedString("wednesday", comment: "")
        static let thursday = NSLocalizedString("thursday", comment: "")
        static let friday = NSLocalizedString("friday", comment: "")
        static let saturday = NSLocalizedString("saturday", comment: "")
        static let sunday = NSLocalizedString("sunday", comment: "")
        static let mondayShort = NSLocalizedString("monday.short", comment: "")
        static let tuesdayShort = NSLocalizedString("tuesday.short", comment: "")
        static let wednesdayShort = NSLocalizedString("wednesday.short", comment: "")
        static let thursdayShort = NSLocalizedString("thursday.short", comment: "")
        static let fridayShort = NSLocalizedString("friday.short", comment: "")
        static let saturdayShort = NSLocalizedString("saturday.short", comment: "")
        static let sundayShort = NSLocalizedString("sunday.short", comment: "")
        static let everyDay = NSLocalizedString("everyDay", comment: "")
        static let unknownMessage = NSLocalizedString("unknown", comment: "")
    }
}
