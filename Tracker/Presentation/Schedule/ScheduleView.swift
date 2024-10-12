//
//  ScheduleView.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import UIKit

final class ScheduleView: UIView {
    
    // MARK: - Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isEmptyHeaderHidden = true

        return tableView
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.doneMessage, for: .normal)
        button.backgroundColor = AppColorSettings.fontColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension ScheduleView {
    
    func setupLayout() {
        addSubviews(
            tableView,
            doneButton
        )
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - Constants

private extension ScheduleView {
    enum Constants {
        static let doneMessage = NSLocalizedString("done", comment: "")
    }
}
