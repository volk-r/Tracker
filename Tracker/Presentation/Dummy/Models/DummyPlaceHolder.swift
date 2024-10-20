//
//  DummyPlaceHolder.swift
//  Tracker
//
//  Created by Roman Romanov on 20.10.2024.
//

import Foundation

enum DummyPlaceHolder {
    case searchEmptyPage
    case statisticEmptyPage
    case trackerEmptyPage
    case categoryEmptyPage
    
    var model: DummyModel {
        switch self {
        case .searchEmptyPage:
            DummyModel(
                description: Constants.dummySearchViewPlaceHolder,
                imageName: AppImages.searchEmptyPage
            )
        case .statisticEmptyPage:
            DummyModel(
                description: Constants.dummyStatisticPlaceHolder,
                imageName: AppImages.statisticEmptyPage
            )
        case .trackerEmptyPage:
            DummyModel(
                description: Constants.dummyTrackerPlaceHolder,
                imageName: AppImages.trackerEmptyPage
            )
        case .categoryEmptyPage:
            DummyModel(
                description: Constants.dummyCategoryViewPlaceHolder,
                imageName: AppImages.trackerEmptyPage
            )
        }
    }
}

// MARK: - Constants

private extension DummyPlaceHolder {
    enum Constants {
        static let dummyStatisticPlaceHolder = NSLocalizedString("statistic.screen.dummyPlaceHolder", comment: "")
        static let dummyTrackerPlaceHolder = NSLocalizedString("tracker.screen.dummyPlaceHolder", comment: "")
        static let dummySearchViewPlaceHolder = NSLocalizedString("tracker.screen.dummySearchPlaceHolder", comment: "")
        static let dummyCategoryViewPlaceHolder = NSLocalizedString("category.screen.dummyPlaceHolder", comment: "")
    }
}
