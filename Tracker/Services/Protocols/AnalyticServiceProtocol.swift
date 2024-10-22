//
//  AnalyticServiceProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 23.10.2024.
//

import Foundation

protocol AnalyticServiceProtocol {
    static func activate()
    func trackOpenScreen(screen: AnalyticScreen)
    func trackCloseScreen(screen: AnalyticScreen)
    func trackClick(screen: AnalyticScreen, item: AnalyticItems)
}
