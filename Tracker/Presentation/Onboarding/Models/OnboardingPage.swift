//
//  OnboardingPage.swift
//  Tracker
//
//  Created by Roman Romanov on 02.10.2024.
//

import Foundation

enum OnboardingPage {
    case first
    case second
    
    var backGroundImageName: String {
        switch self {
        case .first: "OnboardingPage_1"
        case .second: "OnboardingPage_2"
        }
    }
    
    var message: String {
        switch self {
        case .first: Constants.messageFirst
        case .second: Constants.messageSecond
        }
    }
}

// MARK: - Constants

private extension OnboardingPage {
    enum Constants {
        static let messageFirst = NSLocalizedString("onboarding.screen.message.first", comment: "")
        static let messageSecond = NSLocalizedString("onboarding.screen.message.second", comment: "")
    }
}
