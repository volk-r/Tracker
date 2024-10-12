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
    
    private lazy var createCategoryView = CreateCategoryView()
    
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
        setupButtons()
        setupTextField()
    }
}

extension CreateCategoryViewController {
    
    // MARK: - setupTextField
    
    func setupTextField() {
        createCategoryView.categoryNameTextField.delegate = self
        createCategoryView.categoryNameTextField.text = editingCategory?.title
    }
    
    // MARK: - setupButtons
    
    private func setupButtons() {
        createCategoryView.doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)

        createCategoryView.categoryNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    // MARK: - didTapDoneButton
    
    @objc private func didTapDoneButton() {
        guard let categoryName = createCategoryView.categoryNameTextField.text else { return }
        
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
    }
    
    // MARK: - editingChanged
    
    @objc private func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let errorIsHidden = text.count < AppConstants.nameLengthRestriction
        createCategoryView.showTrackerNameError(errorIsHidden)
        let isDoneButtonHidden = !text.isEmpty && errorIsHidden
        createCategoryView.doDoneButtonActive(isDoneButtonHidden)
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
