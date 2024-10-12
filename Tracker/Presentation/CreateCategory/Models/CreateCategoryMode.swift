//
//  CreateCategoryMode.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import Foundation

enum CreateCategoryMode {
    case create
    case edit
    
    var title: String {
        switch self {
            case .create: Constants.createTitle
            case .edit: Constants.editTitle
        }
    }
}

private extension CreateCategoryMode {
    enum Constants {
        static let createTitle = NSLocalizedString("category.new", comment: "")
        static let editTitle = NSLocalizedString("category.edit", comment: "")
    }
}
