//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var cellDelegate: ScheduleViewControllerCellDelegate?
    weak var delegate: ScheduleViewControllerDelegate?
    
    private lazy var scheduleView = ScheduleView(delegate: self)
    
    private var selectedWeekdays: Set<WeekDay>
    
    // MARK: - Init
    
    init(selectedWeekdays: [WeekDay], delegate: ScheduleViewControllerDelegate) {
        self.selectedWeekdays = Set(selectedWeekdays)
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = scheduleView
        title = Constants.pageTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

extension ScheduleViewController {
    
    // MARK: - setupTableView
    
    func setupTableView() {
        scheduleView.setupTableView(source: self)
    }
}

// MARK: - ScheduleViewDelegate

extension ScheduleViewController: ScheduleViewDelegate {
    func tapDoneButton() {
        let weekdays = Array(selectedWeekdays).sorted()
        delegate?.didConfirmSchedule(weekdays)
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewHeightForRowAt
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleTableViewCell.identifier,
            for: indexPath
        )
        
        guard let scheduleCell = cell as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        
        let weekday = WeekDay.allCases[indexPath.row]
        let model = WeekDayModel(
            day: weekday,
            isSelected: selectedWeekdays.contains(weekday)
        )
        scheduleCell.setupCell(with: model)
        scheduleCell.delegate = self
        scheduleView.reloadTableViewRows(at: [indexPath])
        
        return scheduleCell
    }
}

// MARK: - ScheduleViewControllerCellDelegate

extension ScheduleViewController: ScheduleViewControllerCellDelegate {
    func didToggleSwitchView(to isSelected: Bool, of weekday: WeekDay) {
        if isSelected {
            selectedWeekdays.insert(weekday)
        } else {
            selectedWeekdays.remove(weekday)
        }
    }
}

// MARK: - Constants

private extension ScheduleViewController {
    enum Constants {
        static let pageTitle = NSLocalizedString("schedule", comment: "")
        
        static let tableViewHeightForRowAt: CGFloat = 75
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    let delegate = NewTrackerViewController(trackerType: TrackerType.habit, delegate: TrackerViewController())
    let viewController = ScheduleViewController(selectedWeekdays: [], delegate: delegate)
    return viewController
}

#endif
