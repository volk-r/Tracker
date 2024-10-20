//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private enum NewTrackerParam: Int {
        case category = 0
        case schedule = 1
        
        var description: String {
            switch self {
            case .category: return Constants.categoryTitle
            case .schedule: return Constants.scheduleTitle
            }
        }
    }
    
    private var trackerType: TrackerType
    private lazy var newTrackerView = NewTrackerView()
    
    private var indexPathCell: [NewTrackerParam: IndexPath] = [:]
    
    private let collectionViewParams = UICollectionView.GeometricParams(cellCount: 6, leftInset: 18, rightInset: 18, topInset: 24, bottomInset: 24, height: 52, cellSpacing: 5)
    
    private var selectedItems: [Int: IndexPath] = [:]
    
    private var data: Tracker.NewTrackerData = Tracker.NewTrackerData() {
        didSet {
            checkDataValidation()
        }
    }
    
    private var category: TrackerCategory? {
        didSet {
            checkDataValidation()
        }
    }
    
    private var isEditMode = false
    
    // MARK: - Init
    
    init(trackerType: TrackerType, delegate: NewTrackerViewControllerDelegate) {
        self.trackerType = trackerType
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    init(
        trackerType: TrackerType,
        delegate: NewTrackerViewControllerDelegate,
        trackerData: Tracker,
        category: TrackerCategory,
        daysCount: Int
    ) {
        self.trackerType = trackerType
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        isEditMode = true
        setDataToEdit(trackerData: trackerData, category: category, daysCount: daysCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = newTrackerView
        title = trackerType.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTextField()
        setupTableView()
        setupButtons()
        addTapGestureToHideKeyboard()
        
        checkDataValidation()
    }
}

extension NewTrackerViewController {
    
    // MARK: - CollectionViewCellTypes
    
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
                return Constants.emoji
            case self.color.rawValue:
                return Constants.color
            default:
                return Constants.unknown
            }
        }
    }
    
    // MARK: - setupTextField
    
    func setupTextField() {
        newTrackerView.trackerNameTextField.delegate = self
    }
    
    // MARK: - setupTableView
    
    func setupTableView() {
        newTrackerView.tableView.delegate = self
        newTrackerView.tableView.dataSource = self
        newTrackerView.tableView.register(
            NewTrackerTableViewCell.self,
            forCellReuseIdentifier: NewTrackerTableViewCell.identifier
        )

        newTrackerView.setHeightTableView(cellsCount: CGFloat(trackerType.paramsCellsCount))
    }
    
    // MARK: - setupCollectionView
    
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
    
    // MARK: - setDataToEdit
    
    func setDataToEdit(trackerData: Tracker, category: TrackerCategory, daysCount: Int) {
        data = Tracker.NewTrackerData(
            id: trackerData.id,
            name: trackerData.name,
            color: trackerData.color,
            emoji: trackerData.emoji,
            schedule: trackerData.schedule,
            isPinned: trackerData.isPinned
        )
        newTrackerView.setupDaysCount(daysCount)
        newTrackerView.trackerNameTextField.text = data.name
        self.category = category
        
        let emojiCellIndexPath = IndexPath(
            row: AppEmojis.firstIndex(of: trackerData.emoji) ?? 0,
            section: CollectionViewCellTypes.emoji.rawValue
        )
        selectedItems[CollectionViewCellTypes.emoji.rawValue] = emojiCellIndexPath

        let colorCellIndexPath = IndexPath(
            row: AppColorSettings.palette.firstIndex(of: trackerData.color) ?? 0,
            section: CollectionViewCellTypes.color.rawValue
        )
        selectedItems[CollectionViewCellTypes.color.rawValue] = colorCellIndexPath
        
        title = trackerType.title
        newTrackerView.createButton.setTitle(Constants.editTrackerTitle, for: .normal)
    }
    
    private func checkDataValidation() {
        guard
            let category,
            !category.title.isEmpty,
            let name = data.name,
            !name.isEmpty,
            data.emoji != nil,
            data.color != nil
        else {
            newTrackerView.doCreateButtonActive(false)
            return
        }
        
        if
            trackerType == TrackerType.habit,
            data.schedule == nil
        {
            newTrackerView.doCreateButtonActive(false)
            return
        }
        
        newTrackerView.doCreateButtonActive(true)
    }
    
    // MARK: - setupButtons
    
    private func setupButtons() {
        newTrackerView.cancelButton.addTarget(self, action: #selector(cancelTapAction), for: .touchUpInside)
        newTrackerView.createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        
        newTrackerView.trackerNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc private func cancelTapAction() {
        dismiss(animated: true)
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        data = data.update(newName: text)
        let errorIsHidden = text.count < AppConstants.nameLengthRestriction
        newTrackerView.showTrackerNameError(errorIsHidden)
    }

    @objc private func didTapCreateButton() {
        guard
            let category = category?.title,
            let name = data.name,
            !name.isEmpty,
            let emoji = data.emoji,
            let color = data.color
        else {
            return
        }

        let newTracker = Tracker(
            id: data.id ?? UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: data.schedule,
            isPinned: data.isPinned ?? false
        )
        
        delegate?
            .didTapConfirmButton(
                categoryTitle: category,
                trackerToAdd: newTracker,
                isEditMode: isEditMode
            )
        
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

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
    
    // MARK: - Setup Collection cells
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch CollectionViewCellTypes.allCases[indexPath.section] {
        case .emoji:
            if let emojiCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.identifier,
                for: indexPath
            ) as? EmojiCollectionViewCell {
                emojiCell.setupCell(with: AppEmojis[indexPath.item])
                
                if selectedItems[indexPath.section] == indexPath {
                    emojiCell.select()
                }
                
                return emojiCell
            }
        case .color:
            if let colorCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.identifier,
                for: indexPath
            ) as? ColorCollectionViewCell {
                colorCell.setupCell(with: AppColorSettings.palette[indexPath.item])
                
                if selectedItems[indexPath.section] == indexPath {
                    colorCell.select()
                }
                
                return colorCell
            }
        }
        
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
    ) -> UIEdgeInsets {
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
    ) -> CGFloat {
        0
    }
    
    // MARK: - collectionView Header
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
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
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 18)
    }
}

// MARK: - UICollectionViewDelegate

extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CellSelectProtocol else {
            return
        }
        
        if let previouslySelectedIndexPath = selectedItems[indexPath.section] {
            guard let previouslySelectedCell = collectionView.cellForItem(at: previouslySelectedIndexPath) as? CellSelectProtocol else {
                return
            }
            previouslySelectedCell.deselect()
        }

        selectedItems[indexPath.section] = indexPath
        cell.select()
        
        switch indexPath.section {
        case CollectionViewCellTypes.emoji.rawValue:
            data = data.update(newEmoji: AppEmojis[indexPath.item])
        case CollectionViewCellTypes.color.rawValue:
            data = data.update(newColor: AppColorSettings.palette[indexPath.item])
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}

// MARK: - UITableViewDataSource

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerType.paramsCellsCount
    }
    
    // MARK: - Setup TableView cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewTrackerTableViewCell.identifier,
            for: indexPath
        )
        
        guard let newTrackerCell = cell as? NewTrackerTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case NewTrackerParam.category.rawValue:
            indexPathCell[.category] = indexPath
            newTrackerCell.setupCell(
                    title: NewTrackerParam.category.description,
                    description: category?.title
                )
        case NewTrackerParam.schedule.rawValue:
            indexPathCell[.schedule] = indexPath
            newTrackerCell.setupCell(
                    title: NewTrackerParam.schedule.description,
                    description: WeekDay.getScheduleString(from: data.schedule)
                )
        default:
            return UITableViewCell()
        }
        
        newTrackerView.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return newTrackerCell
    }
}

// MARK: - UITableViewDelegate

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let cellCount = tableView.numberOfRows(inSection: indexPath.section)
        cell.setCustomStyle(indexPath: indexPath, cellCount: cellCount)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case NewTrackerParam.category.rawValue:
            let categoryViewController = CategoryViewController(
                selectedCategory: category,
                delegate: self
            )

            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        case NewTrackerParam.schedule.rawValue:
            let schedule = data.schedule ?? []
            let scheduleViewController = ScheduleViewController(
                selectedWeekdays: schedule,
                delegate: self
            )

            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            present(navigationController, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - ScheduleViewControllerDelegate

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didConfirmSchedule(_ schedule: [WeekDay]) {
        data = data.update(newSchedule: schedule)
        let indexPathCell = indexPathCell.filter{ $0.key == NewTrackerParam.schedule }
        
        guard let indexPath = indexPathCell.values.first else { return }
        newTrackerView.tableView.reloadRows(at: [indexPath], with: .automatic)
        dismiss(animated: true)
    }
}

// MARK: - CategoryViewControllerDelegate

extension NewTrackerViewController: CategoryViewControllerDelegate {
    func didSelectCategory(_ selectedCategory: TrackerCategory) {
        category = selectedCategory
        let indexPathCell = indexPathCell.filter{ $0.key == NewTrackerParam.category }
        
        guard let indexPath = indexPathCell.values.first else { return }
        newTrackerView.tableView.reloadRows(at: [indexPath], with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Constants

private extension NewTrackerViewController {
    enum Constants {
        static let categoryTitle = NSLocalizedString("category", comment: "")
        static let scheduleTitle = NSLocalizedString("schedule", comment: "")
        static let emoji = "Emoji"
        static let color = NSLocalizedString("color", comment: "")
        static let unknown = NSLocalizedString("unknown", comment: "")
        
        static let editTrackerTitle = NSLocalizedString("save", comment: "")
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview("Habit") {
    let delegate = TrackerViewController()
    let viewController = NewTrackerViewController(trackerType: .habit, delegate: delegate)
    return viewController
}

@available(iOS 17, *)
#Preview("Event") {
    let delegate = TrackerViewController()
    let viewController = NewTrackerViewController(trackerType: .event, delegate: delegate)
    return viewController
}

#endif
