//
//  FilterViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 19.10.2024.
//

import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: - Properties
    
//    weak var delegate: FilterViewControllerDelegate?
    
    private lazy var filterView = FilterView()
    
    // MARK: - Lifecycle
    
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
        filterView.tableView.delegate = self
        filterView.tableView.dataSource = self
        
        filterView.tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewCell.identifier
        )
        
        filterView.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
//        if
//            let selectedIndexPath = viewModel.selectedIndexPath,
//            selectedIndexPath != indexPath
//        {
//            let previousCell = tableView.cellForRow(at: selectedIndexPath)
//            previousCell?.accessoryType = .none
//            tableView.deselectRow(at: selectedIndexPath, animated: true)
//        }
//
//        let currentCell = tableView.cellForRow(at: indexPath)
//        currentCell?.accessoryType = .checkmark
//        tableView.deselectRow(at: indexPath, animated: true)
//        viewModel.selectCategoryBy(indexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.identifier,
            for: indexPath
        )
        
        guard let categoryCell = cell as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let title = FilterType.allCases[indexPath.row].title
//        let isSelected = category.id == selectedCategory?.id
//        
//        if isSelected {
//            viewModel.saveSelected(indexPath: indexPath)
//        }
        
        categoryCell.setupCell(title: title, isSelected: false)
//        filterView.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return categoryCell
    }
}

// MARK: - Constants

private extension FilterViewController {
    enum Constants {
        static let pageTitle = NSLocalizedString("filters", comment: "")
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    let viewController = FilterViewController()
    viewController
}

#endif
