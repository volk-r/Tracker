//
//  StatisticView.swift
//  Tracker
//
//  Created by Roman Romanov on 26.08.2024.
//

import UIKit

final class StatisticView: UIView {
    // MARK: PROPERTIES
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.textColor = AppColorSettings.fontColor
        label.text = "Статистика"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    lazy var statisticCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
        
        return collectionView
    }()
    
    lazy var placeHolderView: UIView = DummyView(description: "Анализировать пока нечего", imageName: AppImages.statisticEmptyPage)
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setupLayout
    private func setupLayout() {
        [
            pageTitle,
            statisticCollectionView,
            placeHolderView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 44),
            pageTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            statisticCollectionView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 10),
            statisticCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            statisticCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            statisticCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            placeHolderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}