//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    
    private lazy var createCategoryView = CreateCategoryView(delegate: self)
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    
    private var createCategoryMode: CreateCategoryMode
    private var editingCategory: TrackerCategory?
    
    // MARK: - Init
    
    init(
        mode: CreateCategoryMode,
        delegate: CreateCategoryViewControllerDelegate,
        editingCategory: TrackerCategory?
    ) {
        self.delegate = delegate
        self.createCategoryMode = mode
        self.editingCategory = editingCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = createCategoryView
        title = createCategoryMode.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
}

extension CreateCategoryViewController {
    
    // MARK: - setupTextField
    
    func setupTextField() {
        createCategoryView.setupTextField(source: self, editingCategory: editingCategory?.title)
    }
}

extension CreateCategoryViewController: CreateCategoryViewDelegate {
    
    // MARK: - didTapDoneButton
    
    func didTapDoneButton() {
        guard let categoryName = createCategoryView.getCategoryName() else { return }
        
        switch createCategoryMode {
        case .create:
            trackerCategoryStore
                .createCategory(
                    with: TrackerCategory(
                        id: UUID(),
                        title: categoryName,
                        trackerList: []
                    )
                )
            break
        case .edit:
            guard let editingCategory else { return }
            
            trackerCategoryStore
                .updateCategory(
                    with: TrackerCategory(
                        id: editingCategory.id,
                        title: categoryName,
                        trackerList: editingCategory.trackerList
                    )
                )
            
            NotificationCenter.default
                .post(
                    name: .categoryNameChanged,
                    object: self,
                    userInfo: ["NewCategoryName": categoryName]
                )
            break
        }
        
        delegate?.acceptChanges()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension CreateCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    let delegate = NewTrackerViewController(trackerType: TrackerType.habit, delegate: TrackerViewController())
    let categoryViewController = CategoryViewController(selectedCategory: nil, delegate: delegate)
    let viewController = CreateCategoryViewController(mode: .create, delegate: categoryViewController, editingCategory: nil)
    viewController
}

#endif
