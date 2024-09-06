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

        static func getNumberOfItemsInSection(_ number: Int) -> Int {
            switch number {
            case self.emoji.rawValue:
                return AppEmojis.count
            case self.color.rawValue:
                return AppColorSettings.palette.count
            default:
                return 0
            }
        }
        
        static func getTitleSection(_ number: Int) -> String {
            switch number {
            case self.emoji.rawValue:
                return "Emoji"
            case self.color.rawValue:
                return "Цвет"
            default:
                return "Unknown"
            }
        }
    }

    // MARK: PROPERTIES
    private var trackerType: TrackerTypes
    private lazy var newTrackerView = NewTrackerView()
    
    private let collectionViewParams = UICollectionView.GeometricParams(cellCount: 6, leftInset: 28, rightInset: 28, topInset: 24, bottomInset: 24, height: 52, cellSpacing: 5)
    
    // MARK: init
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
    // MARK: setupCollectionView
    func setupCollectionView() {
        newTrackerView.collectionView.dataSource = self
        newTrackerView.collectionView.delegate = self
        
        newTrackerView.collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.identifier
        )
        
        newTrackerView.collectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier
        )
        
        newTrackerView.collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier
        )
    }
}

// MARK: UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        CollectionViewCellTypes.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        CollectionViewCellTypes.getNumberOfItemsInSection(section)
    }
    
    // MARK: SETUP CELLS
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case CollectionViewCellTypes.emoji.rawValue:
            if let emojiCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.identifier,
                for: indexPath
            ) as? EmojiCollectionViewCell {
                
                emojiCell.prepareForReuse()
                emojiCell.setupCell(
                    with: AppEmojis[indexPath.item]
                )
                
                return emojiCell
            }
        case CollectionViewCellTypes.color.rawValue:
            if let colorCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.identifier,
                for: indexPath
            ) as? ColorCollectionViewCell {
                
                colorCell.prepareForReuse()
                colorCell.setupCell(
                    with: AppColorSettings.palette[indexPath.item]
                )
                
                return colorCell
            }
        default:
            return UICollectionViewCell()
        }
        
        return UICollectionViewCell()
    }
    
    // TODO: headers
    // TODO: textfields
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView
    {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SupplementaryView.identifier,
                for: indexPath
            ) as? SupplementaryView
        else {
            return UICollectionReusableView()
        }
        
        let sectionTitle = CollectionViewCellTypes.getTitleSection(indexPath.section)
        view.setupCell(title: sectionTitle)
        
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize
    {
        let indexPath = IndexPath(
            row: 0,
            section: section
        )
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
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
