//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 22.08.2024.
//

import UIKit

class TrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var trackerView = TrackerView()
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    private var trackerStore: TrackerStoreProtocol = TrackerStore()
    private var trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore()

    private var completedTrackers: Set<TrackerRecord> = []
    private var filteredCategories: [TrackerCategory] = [TrackerCategory]() {
        didSet {
            showPlaceHolder()
        }
    }
    private var categories: [TrackerCategory] = [TrackerCategory]() {
        didSet {
            getCompletedTrackers()
            updateFilteredCategories()
        }
    }
    private var filter: FilterType? {
        didSet {
            userAppSettingsStorage.selectedFilter = filter
            trackerView.isFilersActive(filter != .all)
            updateFilteredCategories()
        }
    }
    
    private var datePicker = UIDatePicker()
    private var currentDate: Date = {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }()
    
    private let collectionViewParams = UICollectionView.GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, topInset: 8, bottomInset: 16, height: 148, cellSpacing: 10)
    private let userAppSettingsStorage = UserAppSettingsStorage.shared
    
    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        filter = userAppSettingsStorage.selectedFilter
        trackerView.isFilersActive(filter != nil && filter != .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        showOnboarding()
        setupButton()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTrackersUpdate),
            name: .categoryNameChanged,
            object: nil
        )
        
        getAllCategories()
    }
}

extension TrackerViewController {
    
    // MARK: - getAllCategories
    
    private func getAllCategories() {
        categories = trackerCategoryStore.fetchAllCategories()
    }
    
    // MARK: - getCompletedTrackers
    
    private func getCompletedTrackers() {
        completedTrackers = Set(trackerRecordStore.fetchAllRecords())
    }
    
    // MARK: - setupSearchTextField
    
    private func setupSearchTextField() {
        trackerView.searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    private func setupPlaceHolder() {
        var noTrackers: Bool = categories.isEmpty
        
        for category in categories {
            noTrackers = category.trackerList.isEmpty
        }
        
        trackerView.setupPlaceHolder(isEmptyCategories: noTrackers)
    }
    
    // MARK: - setupDatePicker
    
    private func setupDatePicker() {
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: Constants.dataPickerLocal)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        // datePicker Layout by design
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - setupNavBar
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: AppImages.addNewTracker), style: .done, target: self, action: #selector(addAction))
        navigationItem.leftBarButtonItem?.tintColor = AppColorSettings.fontColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: - datePickerValueChanged
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        showPlaceHolder()
        updateFilteredCategories()
    }
    
    // MARK: - setupCollectionView
    
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
    
    // MARK: - setupButtons
    
    private func setupButton() {
        trackerView.filterCallback = { [weak self] in
            guard let self else { return }
            let filtersVC = FilterViewController(
                selectedFilter: filter,
                delegate: self
            )
            self.present(UINavigationController(rootViewController: filtersVC), animated: true)
        }
    }
    
    @objc private func addAction() {
        let createTrackerVC = CreateTrackerViewController(delegate: self)
        present(UINavigationController(rootViewController: createTrackerVC), animated: true)
    }
    
    @objc private func searchTextChanged() {
        updateFilteredCategories()
    }
    
    private func updateFilteredCategories() {
        switch filter {
        case .all, .none:
            filterAllTrackers()
        case .today:
            filterTodayTrackers { id in
                true
            }
        case .completed:
            filterTodayTrackers { id in
                completedTrackers
                    .contains {
                        $0.trackerId == id && $0.date == currentDate
                    }
            }
        case .notCompleted:
            filterTodayTrackers { id in
                !completedTrackers
                    .contains {
                        $0.trackerId == id && $0.date == currentDate
                    }
            }
        }
        
        trackerView.trackerCollectionView.reloadData()
    }
    
    private func filterAllTrackers() {
        var result = [TrackerCategory]()
        
        let filterText = (trackerView.searchTextField.text ?? "").lowercased()
        
        for category in categories {
            let filteredTrackers = category.trackerList.filter { tracker in
                let isFilteredByText = filterText.isEmpty || tracker.name.localizedCaseInsensitiveContains(filterText)
                
                guard tracker.schedule != nil else { return isFilteredByText }
                return isFilteredByText
            }
            
            if !filteredTrackers.isEmpty {
                result
                    .append(
                        TrackerCategory(
                            id: category.id,
                            title: category.title,
                            trackerList: filteredTrackers
                        )
                    )
            }
        }
        
        filteredCategories = sortCategories(result)
    }
    
    private func filterTodayTrackers(additionalFilter: ((UUID) -> Bool)) {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        var result = [TrackerCategory]()
        
        guard
            let selectedWeekday = WeekDay(rawValue: weekday)
        else {
            return filteredCategories = result
        }
        
        let filterText = (trackerView.searchTextField.text ?? "").lowercased()
        
        for category in categories {
            let filteredTrackers = category.trackerList.filter { tracker in
                let isFilteredByText = filterText.isEmpty || tracker.name.localizedCaseInsensitiveContains(filterText)
                
                guard let schedule = tracker.schedule else { return isFilteredByText && additionalFilter(tracker.id) }
                return schedule.contains(selectedWeekday) && isFilteredByText && additionalFilter(tracker.id)
            }
            
            if !filteredTrackers.isEmpty {
                result
                    .append(
                        TrackerCategory(
                            id: category.id,
                            title: category.title,
                            trackerList: filteredTrackers
                        )
                    )
            }
        }
        
        filteredCategories = sortCategories(result)
    }
    
    private func sortCategories(_ categories: [TrackerCategory]) -> [TrackerCategory] {
        var cleanCategories: [TrackerCategory] = []
        var pinnedTrackerList: [Tracker] = []
        
        categories.forEach { category in
            var trackers: [Tracker] = []
            var pinnedTrackers: [Tracker] = []
            
            category.trackerList.forEach { trackerData in
                let isPinned = trackerData.isPinned
                isPinned
                    ? pinnedTrackers.append(trackerData)
                    : trackers.append(trackerData)
            }
            
            if !pinnedTrackers.isEmpty {
                pinnedTrackerList.append(contentsOf: pinnedTrackers)
            }
            
            if !trackers.isEmpty {
                cleanCategories
                    .append(
                        TrackerCategory(
                            id: category.id,
                            title: category.title,
                            trackerList: trackers.sorted(by: {$0.name > $1.name})
                        )
                    )
            }
        }
        
        if !pinnedTrackerList.isEmpty {
            let pinnedCategory = TrackerCategory(
                id: UUID(),
                title: Constants.pinnedCategory,
                trackerList: pinnedTrackerList.sorted(by: {$0.name > $1.name})
            )
            cleanCategories.insert(pinnedCategory, at: 0)
        }
        
        return cleanCategories
    }
    
    // MARK: - showPlaceHolder
    
    private func showPlaceHolder() {
        setupPlaceHolder()
        trackerView.showPlaceHolder(isVisible: !filteredCategories.isEmpty)
    }
    
    // MARK: - showOnboarding
    
    private func showOnboarding() {
        // TODO: for tests
//        userAppSettingsStorage.clean()
        guard !userAppSettingsStorage.isOnboardingVisited else { return }
        
        userAppSettingsStorage.isOnboardingVisited = true
        let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension TrackerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            trackerView.showFilterButton()
            let height = scrollView.frame.size.height
            let contentYOffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYOffset
            
            if distanceFromBottom < height {
                trackerView.hideFilterButton()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackerList.count
    }
    
    // MARK: - SETUP Collection CELLS
    
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

// MARK: - UICollectionViewDelegate

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
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
        return 9
    }
    
    // MARK: - SETUP Collection HEADER
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize
    {
        // dynamic sizing instead of hard code like as
        // CGSize(width: collectionView.bounds.width, height: 18)
        let headerView = TrackerCollectionViewHeader(frame: .zero)
        headerView.titleLabel.text = filteredCategories[section].title
        return headerView
            .systemLayoutSizeFitting(
                CGSize(
                    width: collectionView.frame.width,
                    height: collectionView.frame.height
                ),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
    }
    
    // MARK: - Tracker context menu
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        let tracker = filteredCategories[indexPath.section].trackerList[indexPath.row]
        let pinUnpinMessage = tracker.isPinned ? Constants.unpinMessage : Constants.pinMessage
        let category = filteredCategories[indexPath.section]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            return UIMenu(
                children: [
                    UIAction(title: pinUnpinMessage) { [weak self] _ in
                        guard let self else { return }
                        
                        let trackerPinned = Tracker(
                            id: tracker.id,
                            name: tracker.name,
                            color: tracker.color,
                            emoji: tracker.emoji,
                            schedule: tracker.schedule,
                            isPinned: !tracker.isPinned
                        )
                        
                        self.trackerStore.updateTrackerPin(trackerPinned)
                    },
                    UIAction(title: Constants.editMessage) { [weak self] _ in
                        guard let self else { return }
                        let daysCount = self.completedTrackers.filter { $0.trackerId == tracker.id }.count
                        let trackerType = (tracker.schedule != nil) ? TrackerType.editHabit : TrackerType.editEvent
                        
                        var realCategory: TrackerCategory? = nil

                        for category in categories {
                            let filteredTrackers = category.trackerList.filter { tracker.id == $0.id
                            }
                            
                            if !filteredTrackers.isEmpty {
                                realCategory = category
                            }
                        }
                        
                        let newTrackerVC = NewTrackerViewController(
                            trackerType: trackerType,
                            delegate: self,
                            trackerData: tracker,
                            category: realCategory ?? category,
                            daysCount: daysCount
                        )
                        self.present(UINavigationController(rootViewController: newTrackerVC), animated: true)
                    },
                    UIAction(title: Constants.deleteMessage, attributes: .destructive) { [weak self] _ in
                        guard let self else { return }
                        self.deleteTracker(tracker)
                    }
                ]
            )
        }
    }
    
    // MARK: - deleteCategory
    
    private func deleteTracker(_ tracker: Tracker) {
        let alert = AlertModel(
            title: nil,
            message: Constants.alertMessage,
            buttonText: Constants.deleteMessage,
            cancelButtonText: Constants.cancelMessage
        ) { [weak self] in
            guard let self else { return }
            self.trackerStore.deleteTracker(tracker)
        }
        
        alertPresenter.showAlert(with: alert)
    }
}

// MARK: - TrackerCollectionViewCellDelegate

extension TrackerViewController: TrackerCollectionViewCellDelegate {
    func didTapAddDayButton(for tracker: Tracker, in cell: TrackerCollectionViewCell) {
        if let completedTracker = completedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            trackerRecordStore.deleteRecord(for: completedTracker)
            cell.decreaseDayCount()
            cell.setupAddDayButton(isCompleted: false)
        } else {
            let trackerRecord = TrackerRecord(id: UUID(), trackerId: tracker.id, date: currentDate)
            trackerRecordStore.addTrackerRecord(with: trackerRecord)
            cell.increaseDayCount()
            cell.setupAddDayButton(isCompleted: true)
        }
    }
}

// MARK: - NewTrackerViewControllerDelegate

extension TrackerViewController: NewTrackerViewControllerDelegate {
    func didTapConfirmButton(categoryTitle: String, trackerToAdd: Tracker, isEditMode: Bool) {
        getAllCategories()
        guard let categoryIndex = categories.firstIndex(where: { $0.title == categoryTitle }) else { return }
        
        if isEditMode {
            trackerStore.updateTracker(trackerToAdd, from: categories[categoryIndex])
            return
        }
        
        trackerStore.addTracker(trackerToAdd, to: categories[categoryIndex])
    }
}

// MARK: - UITextFieldDelegate

extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}

// MARK: - TrackerStoreDelegate

extension TrackerViewController: TrackerStoreDelegate {
    @objc func didTrackersUpdate() {
        getAllCategories()
    }
}

// MARK: - CreateTrackerViewControllerDelegate

extension TrackerViewController: CreateTrackerViewControllerDelegate {
    func didSelectedTypeTracker(trackerType: TrackerType) {
        dismiss(animated: true)
        let newTrackerVC = NewTrackerViewController(trackerType: trackerType, delegate: self)
        present(UINavigationController(rootViewController: newTrackerVC), animated: true)
    }
}

// MARK: - FilterViewControllerDelegate

extension TrackerViewController: FilterViewControllerDelegate {
    func filterChangedTo(_ newFilter: FilterType) {
        filter = newFilter
    }
}

// MARK: - Constants

private extension TrackerViewController {
    enum Constants {
        static let dataPickerLocal = NSLocalizedString("datePicker", comment: "")
        static let pinnedCategory = NSLocalizedString("tracker.screen.pinnedCategory", comment: "")
        static let pinMessage = NSLocalizedString("pin", comment: "")
        static let unpinMessage = NSLocalizedString("unpin", comment: "")
        static let editMessage = NSLocalizedString("edit", comment: "")
        static let deleteMessage = NSLocalizedString("delete", comment: "")
        
        static let cancelMessage = NSLocalizedString("cancel", comment: "")
        static let alertMessage = NSLocalizedString("tracker.screen.alertMessage", comment: "")
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    TrackerViewController()
}

#endif
