//
//  CreateCategoryView.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import UIKit

final class CreateCategoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CreateCategoryViewDelegate?
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.textFieldPlaceholder
        textField.backgroundColor = AppColorSettings.chosenItemBackgroundColor
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.doneMessage, for: .normal)
        button.setTitleColor(AppColorSettings.backgroundColor, for: .normal)
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
        label.text = String(format: Constants.validationTitleMessage, AppConstants.nameLengthRestriction)
        label.textColor = AppColorSettings.redColor
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(delegate: CreateCategoryViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = AppColorSettings.backgroundColor
        setupLayout()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateCategoryView {
    
    // MARK: - setupTextField
    
    func setupTextField(source: CreateCategoryViewController, editingCategory: String?) {
        categoryNameTextField.delegate = source
        categoryNameTextField.text = editingCategory
    }
    
    // MARK: - getCategoryName
    
    func getCategoryName() -> String? {
        categoryNameTextField.text
    }
    
    // MARK: - setupButtons
    
    private func setupButtons() {
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        categoryNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc private func didTapDoneButton() {
        delegate?.didTapDoneButton()
    }
    
    // MARK: - editingChanged
    
    @objc private func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let errorIsHidden = text.count < AppConstants.nameLengthRestriction
        showTrackerNameError(errorIsHidden)
        let isDoneButtonHidden = !text.isEmpty && errorIsHidden
        doDoneButtonActive(isDoneButtonHidden)
    }
    
    // MARK: - Layout
    
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
    
    private func showTrackerNameError(_ show: Bool) {
        errorLabel.isHidden = show
    }
    
    private func doDoneButtonActive(_ isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled
            ? AppColorSettings.fontColor
            : AppColorSettings.notActiveFontColor
    }
}

// MARK: - Constants

private extension CreateCategoryView {
    enum Constants {
        static let textFieldPlaceholder = NSLocalizedString("createCategory.screen.textFieldPlaceholder", comment: "")
        static let validationTitleMessage = NSLocalizedString("validation.title.message", comment: "")
        static let doneMessage = NSLocalizedString("done", comment: "")
    }
}
