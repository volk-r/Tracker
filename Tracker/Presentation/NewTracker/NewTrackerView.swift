//
//  NewTrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class NewTrackerView: UIView {
    
    // MARK: - Properties
    
    lazy var trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.trackerNameTextFieldPlaceholder
        textField.backgroundColor = AppColorSettings.chosenItemBackgroundColor
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.separatorColor = AppColorSettings.notActiveFontColor
        tableView.isEmptyHeaderHidden = true
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
        collectionViewLayout?.collectionView?.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var daysCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 40
        return stackView
    }()
    
    private var tableViewTopConstraint: NSLayoutConstraint?
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.cancelCreateTrackerTitle, for: .normal)
        button.setTitleColor(AppColorSettings.redColor, for: .normal)
        button.backgroundColor = AppColorSettings.backgroundColor
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColorSettings.redColor.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.createTrackerTitle, for: .normal)
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
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
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
 
extension NewTrackerView {
    
    // MARK: - setupLayout
    
    private func setupLayout() {
        [
            scrollView,
            contentView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        // header body
        [
            daysCountLabel,
            trackerNameTextField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerStackView.addArrangedSubview($0)
        }
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
            headerStackView,
            errorLabel,
            tableView,
            collectionView,
            footerStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 2)
        tableViewTopConstraint?.isActive = true
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 75)
        tableViewHeightConstraint?.isActive = true
        
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
            
            headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 63),
            
            errorLabel.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 430),

            footerStackView.topAnchor.constraint(greaterThanOrEqualTo: collectionView.bottomAnchor, constant: 40),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            footerStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - setHeightTableView
    
    func setHeightTableView(cellsCount multiplier: CGFloat) {
        tableViewHeightConstraint?.constant = 75 * multiplier
    }
    
    // MARK: - showTrackerNameError
    
    func showTrackerNameError(_ show: Bool) {
        errorLabel.isHidden = show
        tableViewTopConstraint?.constant = show ? 2 : 32
    }
    
    // MARK: - doCreateButtonActive
    
    func doCreateButtonActive(_ isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled
            ? AppColorSettings.fontColor
            : AppColorSettings.notActiveFontColor
    }
    
    // MARK: - setupDayCount
    
    func setupDaysCount(_ dayCount: Int) {
        daysCountLabel.isHidden = false
        let dayString = String.localizedStringWithFormat(
            Constants.numberOfDaysMessage,
            dayCount
        )
        daysCountLabel.text = dayString
    }
}

// MARK: - Constants

private extension NewTrackerView {
    enum Constants {
        static let trackerNameTextFieldPlaceholder = NSLocalizedString("newTracker.screen.textFieldPlaceholder", comment: "")
        static let cancelCreateTrackerTitle = NSLocalizedString("cancel", comment: "")
        static let createTrackerTitle = NSLocalizedString("create", comment: "")
        static let validationTitleMessage = NSLocalizedString("validation.title.message", comment: "")
        static let numberOfDaysMessage = NSLocalizedString("numberOfDays", comment: "Number of days completed")
    }
}
