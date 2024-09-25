//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: PROPERTIES
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private enum NewTrackerParam: Int {
        case category = 0
        case schedule = 1
        
        var description: String {
            switch self {
            case .category: return "Категория"
            case .schedule: return "Расписание"
            }
        }
    }
    
    private var trackerType: TrackerType
    private lazy var newTrackerView = NewTrackerView()
    
    private var indexPathCell: [NewTrackerParam: IndexPath]?
    
    private let collectionViewParams = UICollectionView.GeometricParams(cellCount: 6, leftInset: 18, rightInset: 18, topInset: 24, bottomInset: 24, height: 52, cellSpacing: 5)
    
    private var selectedItems: [Int: IndexPath] = [:]
    
    private var data: Tracker.NewTrackerData = Tracker.NewTrackerData() {
        didSet {
            checkDataValidation()
        }
    }
    // TODO: gag
    private var category: String? = "Важное" {
        didSet {
            checkDataValidation()
        }
    }
    
    // MARK: INIT
    init(trackerType: TrackerType, delegate: NewTrackerViewControllerDelegate) {
        self.trackerType = trackerType
        self.delegate = delegate
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
        setupTextField()
        setupTableView()
        setupButtons()
        addTapGestureToHideKeyboard()
        
        checkDataValidation()
    }
}

extension NewTrackerViewController {
    // MARK: CollectionViewCellTypes
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
    
    // MARK: setupTextField
    func setupTextField() {
        newTrackerView.trackerNameTextField.delegate = self
    }
    
    // MARK: setupTableView
    func setupTableView() {
        newTrackerView.tableView.delegate = self
        newTrackerView.tableView.dataSource = self
        newTrackerView.tableView.register(
            NewTrackerTableViewCell.self,
            forCellReuseIdentifier: NewTrackerTableViewCell.identifier
        )
        
        newTrackerView.tableView.separatorStyle = trackerType.paramsCellsCount == 1
            ? .none
            : .singleLine
        newTrackerView.setHeightTableView(cellsCount: CGFloat(trackerType.paramsCellsCount))
    }
    
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
    
    private func checkDataValidation() {
        guard
            let category,
            !category.isEmpty,
            let name = data.name,
            !name.isEmpty,
            let emoji = data.emoji,
            let color = data.color
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
    
    // MARK: setupButtons
    private func setupButtons() {
        newTrackerView.cancelButton.addTarget(self, action: #selector(cancelTapAction), for: .touchUpInside)
        newTrackerView.createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        
        newTrackerView.trackerNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc private func cancelTapAction() {
        dismiss(animated: true)
        delegate?.didTapCancelButton()
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        data.name = text
        let errorIsHidden = text.count < 38
        newTrackerView.showTrackerNameError(errorIsHidden)
    }

    @objc private func didTapCreateButton() {
        guard
            let category,
            let name = data.name,
            !name.isEmpty,
            let emoji = data.emoji,
            let color = data.color
        else {
            return
        }

        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: data.schedule
        )
        delegate?.didTapConfirmButton(categoryTitle: category, trackerToAdd: newTracker)
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
    
    // MARK: SETUP Collection CELLS
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
                emojiCell.prepareForReuse()
                
                if selectedItems[indexPath.section] == indexPath {
                    emojiCell.select()
                }
                
                emojiCell.setupCell(with: AppEmojis[indexPath.item])
                
                return emojiCell
            }
        case .color:
            if let colorCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.identifier,
                for: indexPath
            ) as? ColorCollectionViewCell {
                colorCell.prepareForReuse()
                
                if selectedItems[indexPath.section] == indexPath {
                    colorCell.select()
                }
                
                colorCell.setupCell(with: AppColorSettings.palette[indexPath.item])
                
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
    
    // MARK: collectionView Header
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

// MARK: UICollectionViewDelegate
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
            data.emoji = AppEmojis[indexPath.item]
        case CollectionViewCellTypes.color.rawValue:
            data.color = AppColorSettings.palette[indexPath.item]
        default:
            break
        }
    }
}

// MARK: UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}

// MARK: UITableViewDataSource
extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerType.paramsCellsCount
    }
    
    // MARK: SETUP TableView CELLS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewTrackerTableViewCell.identifier,
            for: indexPath
        )
        
        guard let newTrackerCell = cell as? NewTrackerTableViewCell else {
            return UITableViewCell()
        }
        
        // TODO: need to setup cell
        switch indexPath.row {
        case NewTrackerParam.category.rawValue:
            indexPathCell = [.category: indexPath]
            newTrackerCell.setupCell(title: NewTrackerParam.category.description, description: category)
        case NewTrackerParam.schedule.rawValue:
            indexPathCell = [.schedule: indexPath]
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

// MARK: UITableViewDataSource
extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case NewTrackerParam.category.rawValue:
            print("Открыть контроллер выбора Категории")
        case NewTrackerParam.schedule.rawValue:
            let schedule = data.schedule ?? []
            let scheduleViewController = ScheduleViewController(selectedWeekdays: schedule, delegate: self)

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

// MARK: ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didConfirmSchedule(_ schedule: [WeekDay]) {
        data.schedule = schedule
        let indexPathCell = indexPathCell?.filter( {
            $0.key == NewTrackerParam.schedule
        } )
        
        guard let indexPath = indexPathCell?.values.first else { return }
        newTrackerView.tableView.reloadRows(at: [indexPath], with: .automatic)
        dismiss(animated: true)
    }
}

// MARK: - SHOW PREVIEW
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
