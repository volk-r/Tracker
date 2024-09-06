//
//  CreateTrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class CreateTrackerView: UIView {
    // MARK: PROPERTIES
    lazy private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 16
        
        return stackView
    }()
    
    lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = AppColorSettings.fontColor
        
        button.accessibilityIdentifier = "habitButton"
        
        return button
    }()
    
    lazy var eventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярные событие", for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = AppColorSettings.fontColor
        
        button.accessibilityIdentifier = "eventButton"
        
        return button
    }()
    
    // MARK: INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            habitButton.widthAnchor.constraint(lessThanOrEqualToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.widthAnchor.constraint(lessThanOrEqualToConstant: 335),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
