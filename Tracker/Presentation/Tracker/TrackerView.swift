//
//  TrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 25.08.2024.
//

import UIKit

final class TrackerView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: TrackerViewDelegate?
    
    var filterCallback: (() -> Void)?
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = Constants.searchPlaceholder
        return textField
    }()
    
    private lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
        collectionViewLayout?.collectionView?.backgroundColor = AppColorSettings.backgroundColor
        
        return collectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.filterButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(AppColorSettings.filterButtonFontColor, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = AppColorSettings.filterButtonBackgroundColor
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var placeHolderView: DummyView = DummyView(model: DummyPlaceHolder.trackerEmptyPage.model)
    
    // MARK: - Init
    
    init(delegate: TrackerViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = AppColorSettings.backgroundColor
        
        setupLayout()
        setupSearchTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackerView {
    
    // MARK: - setupCollectionView
    
    func setupCollectionView(source: TrackerViewController) {
        trackerCollectionView.dataSource = source
        trackerCollectionView.delegate = source
        trackerCollectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        
        trackerCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
    }
    
    func reloadCollection() {
        trackerCollectionView.reloadData()
    }
    
    // MARK: - PlaceHolder actions

    func showPlaceHolder(isVisible: Bool) {
        placeHolderView.isHidden = isVisible
    }
    
    func setupPlaceHolder(isEmptyTrackers: Bool) {
        placeHolderView
            .setupNewModel(
                model: isEmptyTrackers
                                      ? DummyPlaceHolder.trackerEmptyPage.model
                                      : DummyPlaceHolder.searchEmptyPage.model
        )
    }
    
    // MARK: - Filter Button actions
    
    func isFilersActive(_ isActive: Bool) {
        let titleColor = isActive
            ? AppColorSettings.filterButtonFontColorActive
            : AppColorSettings.filterButtonFontColor
        filterButton.setTitleColor(titleColor, for: .normal)
    }
    
    func showFilterButton() {
        filterButton.alpha = 1
    }
    
    func hideFilterButton() {
        UIView.animate(withDuration: 1.5, delay: 0.3) {
            self.filterButton.alpha = 0
        }
    }
    
    @objc private func didTapFilterButton() {
        filterCallback?()
    }
    
    func filterButton(isHidden: Bool) {
        filterButton.isHidden = isHidden
    }
    
    // MARK: - setupSearchTextField
    
    private func setupSearchTextField() {
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    @objc private func searchTextChanged() {
        delegate?.searchTextChanged()
    }
    
    func getSearchText() -> String {
        searchTextField.text ?? ""
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubviews(
            searchTextField,
            trackerCollectionView,
            placeHolderView,
            filterButton
        )
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            trackerCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            trackerCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            placeHolderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Constants

private extension TrackerView {
    enum Constants {
        static let searchPlaceholder = NSLocalizedString("searchPlaceholder", comment: "")
        static let filterButtonTitle = NSLocalizedString("filters", comment: "")
    }
}
