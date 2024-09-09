//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 22.08.2024.
//

import UIKit

class TrackerViewController: UIViewController {
    // MARK: PROPERTIES
    private lazy var trackerView = TrackerView()
    
    private var categories: [TrackerCategory] = [] {
        didSet {
            trackerView.placeHolderView.isHidden = !categories.isEmpty
        }
    }
    private var completedTrackers: Set<TrackerRecord> = []
    
    private var datePicker = UIDatePicker()
    private var currentDate: Date = {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }()
    
    private let collectionViewParams = UICollectionView.GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, topInset: 8, bottomInset: 16, height: 148, cellSpacing: 10)
    
    // MARK: Lifestyle
    override func loadView() {
        super.loadView()
        view = trackerView
        
        // TODO: Mock Data
        categories = MockTrackerCategoryData
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        setupDatePicker()
    }
}

extension TrackerViewController {
    // MARK: setupDatePicker
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_CH")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        // datePicker Layout by design
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    // MARK: setupNavBar
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: AppImages.addNewTracker), style: .done, target: self, action: #selector(addAction))
        navigationItem.leftBarButtonItem?.tintColor = AppColorSettings.fontColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: datePickerValueChanged
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
    
    // MARK: setupCollectionView
    private func setupCollectionView() {
        trackerView.trackerCollectionView.dataSource = self
        trackerView.trackerCollectionView.delegate = self
        trackerView.trackerCollectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        
        trackerView.trackerCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
    }
    
    // MARK: setupButtons
    @objc private func addAction() {
        let createTrackerVC = CreateTrackerViewController()
        present(UINavigationController(rootViewController: createTrackerVC), animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackerList.count
    }
    
    // MARK: SETUP Collection CELLS
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard 
            let trackerCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCollectionViewCell.identifier,
                for: indexPath
            ) as? TrackerCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let tracker = categories[indexPath.section].trackerList[indexPath.row]
        
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        // TODO: completed days
        trackerCell.setupCell(with: tracker, days: 0, isCompleted: isCompleted)
        trackerCell.delegate = self

        return trackerCell
    }
}

// MARK: UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableSpace = collectionView.frame.width - collectionViewParams.paddingWidth
        let cellWidth = availableSpace / collectionViewParams.cellCount
        return CGSize(width: cellWidth, height: collectionViewParams.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(
            top: collectionViewParams.topInset,
            left: collectionViewParams.leftInset,
            bottom: collectionViewParams.bottomInset,
            right: collectionViewParams.rightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    // MARK: SETUP Collection HEADER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerCollectionViewHeader.identifier,
                for: indexPath
            ) as? TrackerCollectionViewHeader
        else {
            return UICollectionReusableView()
        }
        
        let title = categories[indexPath.section].title
        view.setupHeaderCell(with: title)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
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

// MARK: TrackerCollectionViewCellDelegate
extension TrackerViewController: TrackerCollectionViewCellDelegate {
    func didTapAddDayButton(for tracker: Tracker, in cell: TrackerCollectionViewCell) {
        if let completedTracker = completedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            completedTrackers.remove(completedTracker)
            cell.decreaseDayCount()
            cell.setupAddDayButton(isCompleted: false)
        } else {
            completedTrackers.insert(
                TrackerRecord(trackerId: tracker.id, date: currentDate)
            )
            cell.increaseDayCount()
            cell.setupAddDayButton(isCompleted: true)
        }
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

import SwiftUI
struct TrackerView_Preview: PreviewProvider {
    static var previews: some View {
        TrackerViewController().showPreview()
    }
}
#endif
