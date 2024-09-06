//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: ENUMS
    private enum CollectionViewCellTypes: Int, CaseIterable {
        case emoji = 0
        case color = 1
    }

    // MARK: PROPERTIES
    private var trackerType: TrackerTypes
    private lazy var newTrackerView = NewTrackerView()
    
    private let collectionViewParams = UICollectionView.GeometricParams(cellCount: 6, leftInset: 28, rightInset: 28, topInset: 24, bottomInset: 24, height: 52, cellSpacing: 5)
    
    // MARK: Lifestyle
    init(trackerType: TrackerTypes) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifestyle
    override func loadView() {
        super.loadView()
        view = newTrackerView
        title = trackerType.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
}

extension NewTrackerViewController {
    func setupCollectionView() {
        newTrackerView.collectionView.dataSource = self
        newTrackerView.collectionView.delegate = self
        newTrackerView.collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
    }
}

// MARK: UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionViewCellTypes.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case CollectionViewCellTypes.emoji.rawValue:
            return AppEmojis.count
        case CollectionViewCellTypes.color.rawValue:
            return AppColorSettings.palette.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell {
            
            emojiCell.prepareForReuse()
            emojiCell.setupCell(with: AppEmojis[indexPath.item])
            
            return emojiCell
        }
        
        // TODO: color cell
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize
    {
        let availableSpace = collectionView.frame.width - collectionViewParams.paddingWidth
        let cellWidth = availableSpace / collectionViewParams.cellCount
        return CGSize(
            width: cellWidth,
            height: collectionViewParams.height
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        collectionViewParams.cellSpacing
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat
    {
        0
    }
}

// MARK: UICollectionViewDelegate
extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

import SwiftUI
struct NewTrackerVC_Preview: PreviewProvider {
    static var previews: some View {
        NewTrackerViewController(trackerType: .habit).showPreview()
        NewTrackerViewController(trackerType: .event).showPreview()
    }
}

#endif
