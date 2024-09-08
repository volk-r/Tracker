//
//  ScheduleTableViewCellProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import Foundation

protocol ScheduleViewControllerCellDelegate: AnyObject {
    func didToggleSwitchView(to isSelected: Bool, of weekday: WeekDay)
}
