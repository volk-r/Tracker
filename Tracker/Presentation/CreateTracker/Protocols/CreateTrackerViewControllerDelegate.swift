//
//  CreateTrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Roman Romanov on 11.09.2024.
//

import Foundation

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didSelectedTypeTracker(trackerType: TrackerType)
}
