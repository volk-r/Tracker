//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: PROPERTIES
    private lazy var scheduleView = ScheduleView()
    
    private var selectedWeekdays: Set<WeekDays> = []
    
    // MARK: Lifestyle
    override func loadView() {
        super.loadView()
        view = scheduleView
        title = "Расписание"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupButtons()
    }
}

extension ScheduleViewController {
    // MARK: setupTableView
    func setupTableView() {
        scheduleView.tableView.delegate = self
        scheduleView.tableView.dataSource = self
        scheduleView.tableView.register(
            ScheduleTableViewCell.self,
            forCellReuseIdentifier: ScheduleTableViewCell.identifier
        )
    }
    
    // MARK: setupButtons
    func setupButtons() {
        scheduleView.doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
    }
    
    @objc private func doneButtonAction() {
        // TODO: send data to NewTrackerViewController
        print("doneButtonAction tapped")
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDays.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleTableViewCell.identifier,
            for: indexPath
        )
        
        guard let scheduleCell = cell as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        
        let weekday = WeekDays.allCases[indexPath.row]
        let model = WeekDayModel(
            day: weekday,
            isSelected: selectedWeekdays.contains(weekday)
        )
        scheduleCell.setupCell(with: model)
        scheduleView.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return scheduleCell
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

import SwiftUI
struct ScheduleVC_Preview: PreviewProvider {
    static var previews: some View {
        ScheduleViewController().showPreview()
    }
}

#endif
