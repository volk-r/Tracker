//
//  TrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 25.08.2024.
//

import UIKit

final class TrackerView: UIView {
    // MARK: PROPERTIES
    lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = "Поиск"
        return textField
    }()
    
    lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
        
        return collectionView
    }()
    
    private lazy var placeHolderView: UIView = DummyView(
        model: DummyModel(
            description: "Что будем отслеживать?",
            imageName: AppImages.trackerEmptyPage
        )
    )
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackerView {
    // MARK: showPlaceHolder
    func showPlaceHolder(isVisible: Bool) {
        placeHolderView.isHidden = isVisible
    }
    
    // MARK: setupLayout
    private func setupLayout() {
        [
            searchTextField,
            trackerCollectionView,
            placeHolderView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
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
            placeHolderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
