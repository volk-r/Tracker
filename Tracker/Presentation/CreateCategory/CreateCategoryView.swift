//
//  CreateCategoryView.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import UIKit

final class CreateCategoryView: UIView {
    
    // MARK: - Properties
    
    lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = AppColorSettings.chosenItemBackgroundColor.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        return textField
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = AppColorSettings.notActiveFontColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "Ограничение \(AppConstants.nameLengthRestriction) символов"
        label.textColor = AppColorSettings.redColor
        label.isHidden = true
        return label
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

extension CreateCategoryView {
    
    private func setupLayout() {
        addSubviews(
            categoryNameTextField,
            errorLabel,
            doneButton
        )
        
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 63),
            
            errorLabel.topAnchor.constraint(equalTo: categoryNameTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 22),

            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func showTrackerNameError(_ show: Bool) {
        errorLabel.isHidden = show
    }
    
    func doDoneButtonActive(_ isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled
            ? AppColorSettings.fontColor
            : AppColorSettings.notActiveFontColor
    }
}
