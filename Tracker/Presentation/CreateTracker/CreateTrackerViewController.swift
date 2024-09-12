//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    // MARK: PROPERTIES
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private lazy var createTrackerView = CreateTrackerView()
    
    init(delegate: CreateTrackerViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifestyle
    override func loadView() {
        super.loadView()
        view = createTrackerView
        title = "Создание трекера"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
}

extension CreateTrackerViewController {
    private func setupButton() {
        createTrackerView.habitButton.addTarget(self, action: #selector(habitButtonTapAction), for: .touchUpInside)
        createTrackerView.eventButton.addTarget(self, action: #selector(eventButtonTapAction), for: .touchUpInside)
    }
    
    @objc private func habitButtonTapAction() {
        delegate?.didSelectedTypeTracker(trackerType: .habit)
    }
    
    @objc private func eventButtonTapAction() {
        delegate?.didSelectedTypeTracker(trackerType: .event)
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

import SwiftUI
struct CreateTracker_Preview: PreviewProvider {
    static var previews: some View {
        let vc = TrackerViewController()
        CreateTrackerViewController(delegate: vc).showPreview()
    }
}
#endif
