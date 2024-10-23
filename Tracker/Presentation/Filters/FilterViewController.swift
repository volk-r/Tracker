//
//  FilterViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 19.10.2024.
//

import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: FilterViewControllerDelegate?
    
    private lazy var filterView = FilterView()
    
    private var selectedIndexPath: IndexPath?
    private var selectedFilter: FilterType?
    
    // MARK: - Lifecycle
    
    init(selectedFilter: FilterType?, delegate: FilterViewControllerDelegate) {
        self.delegate = delegate
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = filterView
        title = Constants.pageTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

extension FilterViewController {
    
    // MARK: - setupTableView
    
    private func setupTableView() {
        filterView.setupTableView(source: self)
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewHeightForRowAt
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let cellCount = tableView.numberOfRows(inSection: indexPath.section)
        cell.setCustomStyle(indexPath: indexPath, cellCount: cellCount)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if
            let selectedIndexPath = selectedIndexPath,
            selectedIndexPath != indexPath
        {
            let previousCell = tableView.cellForRow(at: selectedIndexPath)
            previousCell?.accessoryType = .none
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }

        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.accessoryType = .checkmark
        selectedIndexPath = indexPath

        let selectedFilter = FilterType.allCases[indexPath.row]
        delegate?.filterChangedTo(selectedFilter)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.identifier,
            for: indexPath
        )
        
        guard let categoryCell = cell as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let currentFilter = FilterType.allCases[indexPath.row]
        let isSelected = currentFilter == selectedFilter
        
        if isSelected {
            selectedIndexPath = indexPath
        }
        
        categoryCell.setupCell(title: currentFilter.title, isSelected: isSelected)
        
        return categoryCell
    }
}

// MARK: - Constants

private extension FilterViewController {
    enum Constants {
        static let pageTitle = NSLocalizedString("filters", comment: "")
        
        static let tableViewHeightForRowAt: CGFloat = 75
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    let delegate = TrackerViewController()
    let viewController = FilterViewController(
        selectedFilter: nil,
        delegate: delegate
    )
    viewController
}

#endif
