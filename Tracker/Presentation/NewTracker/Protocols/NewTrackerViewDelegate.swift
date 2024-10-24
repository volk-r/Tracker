//
//  NewTrackerViewDelegate.swift
//  Tracker
//
//  Created by Roman Romanov on 24.10.2024.
//

import Foundation

protocol NewTrackerViewDelegate: AnyObject {
    func setTrackerNameTo(_ newTrackerName: String)
    func didTapCancelButton()
    func didTapCreateButton()
}
