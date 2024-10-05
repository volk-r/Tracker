//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    // MARK: PROPERTIES
    weak var delegate: CategoryViewControllerDelegate?
    
    private lazy var categoryView = CategoryView()
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    
    private var selectedCategory: TrackerCategory?
    private var categories: [TrackerCategory] = [TrackerCategory]() {
        didSet {
            showPlaceHolder()
        }
    }
    private var selectedIndexPath: IndexPath?
    
    // MARK: INIT
    init(selectedCategory: TrackerCategory?, delegate: CategoryViewControllerDelegate) {
        self.delegate = delegate
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        view = categoryView
        title = "Категория"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCategories()
        setupButtons()
        setupTableView()
    }
}

extension CategoryViewController {
    // MARK: getAllCategories
    private func getAllCategories() {
        categories = trackerCategoryStore.fetchAllCategories()
        print("categories", categories)
    }
    
    // MARK: showPlaceHolder
    private func showPlaceHolder() {
        categoryView.showPlaceHolder(isVisible: !categories.isEmpty)
    }
    
    // MARK: setupButtons
    private func setupButtons() {
        categoryView.createButton.addTarget(self, action: #selector(createButtonTapAction), for: .touchUpInside)
    }
    
    // MARK: setupTableView
    private func setupTableView() {
        categoryView.tableView.delegate = self
        categoryView.tableView.dataSource = self
        
        categoryView.tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewCell.identifier
        )
        
        categoryView.tableView.separatorStyle = categories.count == 1
            ? .none
            : .singleLine
    }
    
    @objc private func createButtonTapAction() {
        print("open CreateCategoryController")
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if
            let selectedIndexPath,
            selectedIndexPath != indexPath
        {
            let previousCell = tableView.cellForRow(at: selectedIndexPath)
            previousCell?.accessoryType = .none
        }
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
        
        tableView.deselectRow(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        delegate?.didSelectCategory(category)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: setupTableView
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.identifier,
            for: indexPath
        )
        
        guard let categoryCell = cell as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.row]
        let isSelected = category.id == selectedCategory?.id
        categoryCell.setupCell(title: category.title, isSelected: isSelected)
        categoryView.tableView.reloadRows(at: [indexPath], with: .automatic)

        return categoryCell
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

@available(iOS 17, *)
#Preview {
    let delegate = NewTrackerViewController(trackerType: TrackerType.habit, delegate: TrackerViewController())
    let viewController = CategoryViewController(selectedCategory: nil, delegate: delegate)
    viewController
}

#endif
