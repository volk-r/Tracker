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
    
    private lazy var trackerStore: TrackerStoreProtocol = TrackerStore(delegate: self)
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    private let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore()

    private var completedTrackers: Set<TrackerRecord> = []
    private var categories: [TrackerCategory] = [TrackerCategory]() {
        didSet {
            showPlaceHolder()
        }
    }
    
    private var filteredCategories: [TrackerCategory] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        var result = [TrackerCategory]()
        
        guard let selectedWeekday = WeekDay(rawValue: weekday) else { return result }
        
        for category in categories {
            let filteredTrackers = category.trackerList.filter { tracker in
                guard let schedule = tracker.schedule else { return true }
                return schedule.contains(selectedWeekday)
            }
            
            if !filteredTrackers.isEmpty {
                result.append(TrackerCategory(id: category.id, title: category.title, trackerList: filteredTrackers))
            }
        }
        
        return result
    }
    
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        setupDatePicker()
        showPlaceHolder()
        setupSearchTextField()
        addTapGestureToHideKeyboard()
        
        getAllCategories()
        
        // TODO: Mock Data
        if categories.isEmpty {
            print("Load Mock Data")
            trackerCategoryStore.createCategory(with: TrackerCategory(id: UUID(), title: "Важное", trackerList: []))
            getAllCategories()
        }
        
        getCompletedTrackers()
    }
}

extension TrackerViewController {
    // MARK: getCompletedTrackers
    private func getAllCategories() {
        categories = trackerCategoryStore.fetchAllCategories()
        print("categories", categories)
    }
    
    // MARK: getCompletedTrackers
    private func getCompletedTrackers() {
        completedTrackers = Set(trackerRecordStore.fetchAllRecords())
        print("completedTrackers", completedTrackers)
    }
    
    // MARK: setupSearchTextField
    private func setupSearchTextField() {
        trackerView.searchTextField.delegate = self
    }
    
    // MARK: setupDatePicker
    private func setupDatePicker() {
        datePicker.maximumDate = Date()
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
        showPlaceHolder()
        trackerView.trackerCollectionView.reloadData()
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
        let createTrackerVC = CreateTrackerViewController(delegate: self)
        present(UINavigationController(rootViewController: createTrackerVC), animated: true)
    }
    
    // MARK: showPlaceHolder
    private func showPlaceHolder() {
        trackerView.placeHolderView.isHidden = !filteredCategories.isEmpty
    }
}

// MARK: UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackerList.count
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
        
        let tracker = filteredCategories[indexPath.section].trackerList[indexPath.row]
        let daysCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }

        trackerCell.setupCell(with: tracker, days: daysCount, isCompleted: isCompleted)
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
        
        let title = filteredCategories[indexPath.section].title
        view.setupHeaderCell(with: title)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        CGSize(width: collectionView.bounds.width, height: 18)
    }
}

// MARK: TrackerCollectionViewCellDelegate
extension TrackerViewController: TrackerCollectionViewCellDelegate {
    func didTapAddDayButton(for tracker: Tracker, in cell: TrackerCollectionViewCell) {
        if let completedTracker = completedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            // TODO:
            print("completedTracker decrease count")
            print(completedTracker)
            trackerRecordStore.deleteRecord(for: completedTracker)
            cell.decreaseDayCount()
            cell.setupAddDayButton(isCompleted: false)
        } else {
            let trackerRecord = TrackerRecord(id: UUID(), trackerId: tracker.id, date: currentDate)
            // TODO:
            print("completedTracker increase count")
            print(trackerRecord)
            trackerRecordStore.addTrackerRecord(with: trackerRecord)
            cell.increaseDayCount()
            cell.setupAddDayButton(isCompleted: true)
        }
    }
}

// MARK: NewTrackerViewControllerDelegate
extension TrackerViewController: NewTrackerViewControllerDelegate {
    func didTapConfirmButton(categoryTitle: String, trackerToAdd: Tracker) {
        guard let categoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) else { return }
        dismiss(animated: true)
        trackerStore.addTracker(trackerToAdd, to: categories[categoryIndex])
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}

extension TrackerViewController: TrackerStoreDelegate {
    func didTrackersUpdate() {
        print("didTrackersUpdate")
        print(categories)
        getAllCategories()
        trackerView.trackerCollectionView.reloadData()
    }
}

// MARK: CreateTrackerViewControllerDelegate
extension TrackerViewController: CreateTrackerViewControllerDelegate {
    func didSelectedTypeTracker(trackerType: TrackerType) {
        dismiss(animated: true)
        let newTrackerVC = NewTrackerViewController(trackerType: trackerType, delegate: self)
        present(UINavigationController(rootViewController: newTrackerVC), animated: true)
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

@available(iOS 17, *)
#Preview {
    TrackerViewController()
}

#endif
