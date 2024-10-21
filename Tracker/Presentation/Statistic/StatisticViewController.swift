//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 25.08.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var statisticView = StatisticView()
    
    private var statisticData: [StatisticModel] = [StatisticModel]() {
        didSet {
            showPlaceHolder()
        }
    }
    
    private let collectionViewParams = UICollectionView.GeometricParams(
        cellCount: 1,
        leftInset: 16,
        rightInset: 16,
        topInset: 24,
        bottomInset: 12,
        height: 90,
        cellSpacing: 12
    )
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = statisticView
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        // TODO:
        statisticData = [StatisticModel(title: "1", description: "Лучший период")]
    }
}

extension StatisticViewController {
    
    // MARK: - setupNavBar
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - showPlaceHolder
    
    private func showPlaceHolder() {
        statisticView.showPlaceHolder(isVisible: !statisticData.isEmpty)
    }
    
    // MARK: - setupCollectionView
    
    private func setupCollectionView() {
        statisticView.statisticCollectionView.dataSource = self
        statisticView.statisticCollectionView.delegate = self
        statisticView.statisticCollectionView.register(
            StatisticCollectionViewCell.self,
            forCellWithReuseIdentifier: StatisticCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource

extension StatisticViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statisticData.count
    }
    
    // MARK: - SETUP Collection CELLS
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let statisticCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StatisticCollectionViewCell.identifier,
                for: indexPath
            ) as? StatisticCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let data = statisticData[indexPath.row]
        
        statisticCell.setupCell(with: data)

        return statisticCell
    }
}

// MARK: - UICollectionViewDelegate

extension StatisticViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize
    {
        let availableSpace = collectionView.frame.width - collectionViewParams.paddingWidth
        let cellWidth = availableSpace / collectionViewParams.cellCount
        return CGSize(width: cellWidth, height: collectionViewParams.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets
    {
        UIEdgeInsets(
            top: collectionViewParams.topInset,
            left: collectionViewParams.leftInset,
            bottom: collectionViewParams.bottomInset,
            right: collectionViewParams.rightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewParams.cellSpacing
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    StatisticViewController()
}

#endif
