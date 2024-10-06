//
//  AlertModel.swift
//  Tracker
//
//  Created by Roman Romanov on 07.10.2024.
//

import Foundation

struct AlertModel {
    let title: String?
    let message: String
    let buttonText: String
    let cancelButtonText: String?
    let completion: (() -> Void)?
}
