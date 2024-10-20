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
        tableView.separatorColor = AppColorSettings.notActiveFontColor
        tableView.isEmptyHeaderHidden = true

        return tableView
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.doneMessage, for: .normal)
        button.setTitleColor(AppColorSettings.backgroundColor, for: .normal)
        button.backgroundColor = AppColorSettings.fontColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
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

extension ScheduleView {
    
    func setupLayout() {
        [
            scrollView,
            contentView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        // body
        [
            tableView,
            doneButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),
            
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(WeekDay.allCases.count * 75)),
            
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 39),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
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
