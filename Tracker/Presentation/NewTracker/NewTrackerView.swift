//
//  NewTrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class NewTrackerView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: NewTrackerViewDelegate?
    
    private lazy var trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.trackerNameTextFieldPlaceholder
        textField.backgroundColor = AppColorSettings.chosenItemBackgroundColor
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.separatorColor = AppColorSettings.notActiveFontColor
        tableView.isEmptyHeaderHidden = true
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
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
    
    private lazy var cancelButton: UIButton = {
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
    
    private lazy var createButton: UIButton = {
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
    
    init(delegate: NewTrackerViewDelegate) {
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
 
extension NewTrackerView {
    
    // MARK: - setupTextField
    
    func setupTextField(source: NewTrackerViewController) {
        trackerNameTextField.delegate = source
    }
    
    // MARK: - setTrackerName
    
    func setTrackerName(trackerName: String?) {
        trackerNameTextField.text = trackerName
    }
    
    // MARK: - setupTableView
    
    func setupTableView(source: NewTrackerViewController) {
        tableView.delegate = source
        tableView.dataSource = source
        tableView.register(
            NewTrackerTableViewCell.self,
            forCellReuseIdentifier: NewTrackerTableViewCell.identifier
        )
    }
    
    func reloadTableViewRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - setHeightTableView
    
    func setHeightTableView(cellsCount multiplier: CGFloat) {
        tableViewHeightConstraint?.constant = Constants.tableHeight * multiplier
    }
    
    // MARK: - setupCollectionView
    
    func setupCollectionView(source: NewTrackerViewController) {
        collectionView.dataSource = source
        collectionView.delegate = source
        
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.identifier
        )
        
        collectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier
        )
        
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier
        )
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
    
    // MARK: - setupButtons
    
    func setCreateButtonTitleTo(_ title: String) {
        createButton.setTitle(title, for: .normal)
    }
    
    private func setupButtons() {
        cancelButton.addTarget(self, action: #selector(cancelTapAction), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
        
        trackerNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc private func cancelTapAction() {
        delegate?.didTapCancelButton()
    }
    
    @objc private func createButtonAction() {
        delegate?.didTapCreateButton()
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        delegate?.setTrackerNameTo(text)
        let errorIsHidden = text.count < AppConstants.nameLengthRestriction
        showTrackerNameError(errorIsHidden)
    }
    
    // MARK: - showTrackerNameError
    
    private func showTrackerNameError(_ show: Bool) {
        errorLabel.isHidden = show
        tableViewTopConstraint?.constant = show ? 2 : 32
    }
    
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
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: Constants.tableHeight)
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
            
            headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.headerInset),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.mainInset),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.mainInset),
            
            trackerNameTextField.heightAnchor.constraint(equalToConstant: Constants.trackerNameTextFieldHeight),
            
            errorLabel.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: Constants.mainInset / 2),
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: Constants.errorLabelHeight),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.mainInset),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.mainInset),

            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Constants.collectionInset),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.collectionHeight),

            footerStackView.topAnchor.constraint(greaterThanOrEqualTo: collectionView.bottomAnchor, constant: Constants.footerInset * 2),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.footerInset),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.footerInset),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            footerStackView.heightAnchor.constraint(equalToConstant: Constants.footerHeight)
        ])
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
        
        static let mainInset: CGFloat = 16
        static let tableHeight: CGFloat = 75
        static let errorLabelHeight: CGFloat = 22
        static let trackerNameTextFieldHeight: CGFloat = 63
        static let footerInset: CGFloat = 20
        static let footerHeight: CGFloat = 60
        static let collectionHeight: CGFloat = 430
        static let collectionInset: CGFloat = 32
        static let headerInset: CGFloat = 24
    }
}
