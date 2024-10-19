//
//  FilterView.swift
//  Tracker
//
//  Created by Roman Romanov on 19.10.2024.
//

import UIKit

final class FilterView: UIView {
    
    // MARK: - Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.separatorColor = AppColorSettings.notActiveFontColor
        tableView.isEmptyHeaderHidden = true
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColorSettings.backgroundColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension FilterView {
    
    private func setupLayout() {
        addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Insets.top.rawValue),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.main.rawValue),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.main.rawValue),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Insets.main.rawValue),
        ])
    }
}

private extension FilterView {
    enum Insets: CGFloat {
        case main = 16
        case top = 24
    }
}
