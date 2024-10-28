//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CategoryViewControllerDelegate?
    
    private lazy var categoryView = CategoryView(delegate: self)
    private lazy var viewModel = CategoryViewModel()
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    private var selectedCategory: TrackerCategory?
    
    // MARK: - init
    
    init(selectedCategory: TrackerCategory?, delegate: CategoryViewControllerDelegate) {
        self.delegate = delegate
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = categoryView
        title = Constants.pageTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        getAllCategories()
    }
}

extension CategoryViewController {
    
    // MARK: - setupBindings
    
    private func setupBindings() {
        viewModel.onCategoriesChanged = { [weak self] categories in
            guard let self else { return }
            self.categoryView.reloadTableView()
            self.showPlaceHolder()
        }
        
        viewModel.onCategorySelected = { [weak self] category in
            guard let self = self else { return }
            self.delegate?.didSelectCategory(category)
        }
    }
    
    // MARK: - getAllCategories
    
    private func getAllCategories() {
        viewModel.loadCategories()
    }
    
    // MARK: - showPlaceHolder
    
    private func showPlaceHolder() {
        categoryView.showPlaceHolder(isVisible: viewModel.numberOfCategories() != 0)
    }
    
    // MARK: - setupTableView
    
    private func setupTableView() {
        categoryView.setupTableView(source: self)
    }
    
    // MARK: - editCategory
    
    private func editCategory(_ category: TrackerCategory) {
        let createCategoryVC = CreateCategoryViewController(
            mode: .edit,
            delegate: self,
            editingCategory: category
        )
        let navigationController = UINavigationController(rootViewController: createCategoryVC)
        present(navigationController, animated: true)
    }
    
    // MARK: - deleteCategory
    
    private func deleteCategory(_ category: TrackerCategory) {
        let alert = AlertModel(
            title: nil,
            message: Constants.alertMessage,
            buttonText: Constants.deleteMessage,
            cancelButtonText: Constants.cancelMessage
        ) { [weak self] in
            guard let self else { return }
            self.viewModel.deleteCategory(category)
        }
        
        alertPresenter.showAlert(with: alert)
    }
}

// MARK: - CategoryViewDelegate

extension CategoryViewController: CategoryViewDelegate {
    func tapCreateButton() {
        let createCategoryVC = CreateCategoryViewController(
            mode: .create,
            delegate: self,
            editingCategory: nil
        )
        let navigationController = UINavigationController(rootViewController: createCategoryVC)
        present(navigationController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
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
            let selectedIndexPath = viewModel.selectedIndexPath,
            selectedIndexPath != indexPath
        {
            let previousCell = tableView.cellForRow(at: selectedIndexPath)
            previousCell?.accessoryType = .none
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.accessoryType = .checkmark
        viewModel.selectCategoryBy(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewHeightForRowAt
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let category = viewModel.categoryBy(index: indexPath.row)
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            UIMenu(children: [
                UIAction(title: Constants.editMessage) { [weak self] _ in
                    guard let self else { return }
                    self.editCategory(category)
                },
                UIAction(title: Constants.deleteMessage, attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.deleteCategory(category)
                }
            ])
        })
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.identifier,
            for: indexPath
        )
        
        guard let categoryCell = cell as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let category = viewModel.categoryBy(index: indexPath.row)
        let isSelected = category.id == selectedCategory?.id
        
        if isSelected {
            viewModel.saveSelected(indexPath: indexPath)
        }
        
        categoryCell.setupCell(title: category.title, isSelected: isSelected)
        
        return categoryCell
    }
}

// MARK: - CategoryViewController

extension CategoryViewController: CreateCategoryViewControllerDelegate {
    func acceptChanges() {
        getAllCategories()
    }
}

// MARK: - Constants

private extension CategoryViewController {
    enum Constants {
        static let pageTitle = NSLocalizedString("category", comment: "")
        static let cancelMessage = NSLocalizedString("cancel", comment: "")
        static let deleteMessage = NSLocalizedString("delete", comment: "")
        static let editMessage = NSLocalizedString("edit", comment: "")
        static let alertMessage = NSLocalizedString("category.screen.alertMessage", comment: "")
        
        static let tableViewHeightForRowAt: CGFloat = 75
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    let delegate = NewTrackerViewController(trackerType: TrackerType.habit, delegate: TrackerViewController())
    let viewController = CategoryViewController(selectedCategory: nil, delegate: delegate)
    viewController
}

#endif
