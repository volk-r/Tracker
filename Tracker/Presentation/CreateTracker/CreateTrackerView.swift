//
//  CreateTrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class CreateTrackerView: UIView {
    // MARK: PROPERTIES
    var trackerCallback: ((TrackerType) -> Void)?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.habitTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.setTitleColor(AppColorSettings.backgroundColor, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = AppColorSettings.fontColor
        button.addTarget(self, action: #selector(didHabitTapped), for: .touchUpInside)
        
        button.accessibilityIdentifier = "HabitButton"
        
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.eventTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.setTitleColor(AppColorSettings.backgroundColor, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = AppColorSettings.fontColor
        button.addTarget(self, action: #selector(didEventTapped), for: .touchUpInside)
        
        button.accessibilityIdentifier = "EventButton"
        
        return button
    }()
    
    // MARK: INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColorSettings.backgroundColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateTrackerView {
    // MARK: LAYOUT
    private func setupLayout() {
        // body
        [
            habitButton,
            eventButton,
        ].forEach {
            mainStackView.addArrangedSubview($0)
        }
        // main elements
        [
            mainStackView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: didHabitTapped
    @objc private func didHabitTapped() {
        trackerCallback?(.habit)
    }
    
    // MARK: didEventTapped
    @objc private func didEventTapped() {
        trackerCallback?(.event)
    }
}

// MARK: - Constants

private extension CreateTrackerView {
    enum Constants {
        static let habitTitle = NSLocalizedString("habit", comment: "")
        static let eventTitle = NSLocalizedString("irregularEvent", comment: "")
    }
}
