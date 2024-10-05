//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject {
    func didCreateCategory(_ category: TrackerCategory)
}
