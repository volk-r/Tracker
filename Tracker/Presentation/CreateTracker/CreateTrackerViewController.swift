//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private lazy var createTrackerView = CreateTrackerView()
    
    // MARK: - Init
    
    init(delegate: CreateTrackerViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = createTrackerView
        title = Constants.pageTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
}

extension CreateTrackerViewController {
    private func setupButton() {
        createTrackerView.trackerCallback = { [weak delegate] type in
            delegate?.didSelectedTypeTracker(trackerType: type)
        }
    }
}

// MARK: - Constants

private extension CreateTrackerViewController {
    enum Constants {
        static let pageTitle = NSLocalizedString("createTracker.screen.title", comment: "")
    }
}

// MARK: - Preview

#if DEBUG

@available(iOS 17, *)
#Preview {
    let delegate = TrackerViewController()
    let viewController = CreateTrackerViewController(delegate: delegate)
    return viewController
}

#endif
