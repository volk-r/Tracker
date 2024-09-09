//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Roman Romanov on 09.09.2024.
//

import Foundation

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didTapAddDayButton(for tracker: Tracker, in cell: TrackerCollectionViewCell)
}
