//
//  NewTrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Roman Romanov on 11.09.2024.
//

import Foundation

protocol NewTrackerViewControllerDelegate: AnyObject {
    func didTapConfirmButton(categoryTitle: String, trackerToAdd: Tracker, isEditMode: Bool)
}
