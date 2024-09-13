//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func didConfirmSchedule(_ schedule: [WeekDay])
}
