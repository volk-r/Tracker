//
//  NewTrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class NewTrackerView: UIView {
    // MARK: PROPERTIES
    var tableViewTopConstraint: NSLayoutConstraint?
    
    lazy var trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = AppColorSettings.chosenItemBackgroundColor.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)

        return textField
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "Ограничение 38 символов"
        label.textColor = AppColorSettings.redColor
        label.isHidden = true
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
        
        return collectionView
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(AppColorSettings.redColor, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColorSettings.redColor.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = AppColorSettings.notActiveFontColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
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
        // footer body
        [
            cancelButton,
            createButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            footerStackView.addArrangedSubview($0)
        }
        // body
        [
            trackerNameTextField,
            errorLabel,
            collectionView,
            footerStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
//        tableViewTopConstraint = parametersTableView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32)
        tableViewTopConstraint = collectionView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 2)
        tableViewTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            trackerNameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerNameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 63),
            
            errorLabel.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
//            collectionView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            footerStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            footerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            footerStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
