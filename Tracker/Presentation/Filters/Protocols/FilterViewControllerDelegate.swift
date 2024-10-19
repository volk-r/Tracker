//
//  FilterViewControllerDelegate.swift
//  Tracker
//
//  Created by Roman Romanov on 20.10.2024.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func filterChangedTo(_ newFilter: FilterType)
}
