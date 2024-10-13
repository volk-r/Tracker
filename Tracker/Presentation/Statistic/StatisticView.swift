//
//  StatisticView.swift
//  Tracker
//
//  Created by Roman Romanov on 26.08.2024.
//

import UIKit

final class StatisticView: UIView {
    
    // MARK: - Properties
    
    private lazy var statisticCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
        collectionViewLayout?.collectionView?.backgroundColor = AppColorSettings.backgroundColor
        
        return collectionView
    }()
    
    private lazy var placeHolderView: UIView = DummyView(
        model: DummyModel(
            description: Constants.dummyViewPlaceHolder,
            imageName: AppImages.statisticEmptyPage
        )
    )
    
    // MARK: - Init
    
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

extension StatisticView {
    
    private func setupLayout() {
        addSubviews(
            statisticCollectionView,
            placeHolderView
        )
        
        NSLayoutConstraint.activate([
            statisticCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            statisticCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            statisticCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            statisticCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            placeHolderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}

// MARK: - Constants

private extension StatisticView {
    enum Constants {
        static let dummyViewPlaceHolder = NSLocalizedString("statistic.screen.dummyPlaceHolder", comment: "")
    }
}
