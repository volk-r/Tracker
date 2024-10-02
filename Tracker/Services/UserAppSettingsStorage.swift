//
//  UserAppSettingsStorage.swift
//  Tracker
//
//  Created by Roman Romanov on 01.10.2024.
//

import Foundation

final class UserAppSettingsStorage: UserAppSettingsStorageProtocol {
    // MARK: PROPERTIES
    static let shared = UserAppSettingsStorage()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case isOnBoardingVisited
    }
    
    var isOnboardingVisited: Bool {
        get {
            userDefaults.bool(forKey: Keys.isOnBoardingVisited.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isOnBoardingVisited.rawValue)
        }
    }
    
    private init() {}
    
    // MARK: clean
    func clean() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { userDefaults.removeObject(forKey: $0) }
    }
}
