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
    
    // MARK: INIT
    init(delegate: CategoryViewControllerDelegate) {
        self.delegate = delegate
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
        setupButtons()
    }
}

extension CategoryViewController {
    // MARK: setupButtons
    private func setupButtons() {
        categoryView.createButton.addTarget(self, action: #selector(createButtonTapAction), for: .touchUpInside)
    }
    
    @objc private func createButtonTapAction() {
        // TODO:
        let newCategory = TrackerCategory(
            id: UUID(),
            title: "",
            trackerList: []
        )
        delegate?.didCreateCategory(newCategory)
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

@available(iOS 17, *)
#Preview {
    let delegate = NewTrackerViewController(trackerType: TrackerType.habit, delegate: TrackerViewController())
    let viewController = CategoryViewController(delegate: delegate)
    viewController
}

#endif
