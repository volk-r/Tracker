//
//  UserAppSettingsStorageProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 01.10.2024.
//

import Foundation

protocol UserAppSettingsStorageProtocol {
    var isOnboardingVisited: Bool { get set }
    func clean()
}
