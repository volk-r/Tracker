//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    // MARK: PROPERTIES
    private var createTrackerView = CreateTrackerView()
    
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
        let newTrackerVC = NewTrackerViewController(trackerType: .habit)
        present(UINavigationController(rootViewController: newTrackerVC), animated: true)
    }
    
    @objc private func eventButtonTapAction() {
        let newTrackerVC = NewTrackerViewController(trackerType: .event)
        present(UINavigationController(rootViewController: newTrackerVC), animated: true)
    }
}

// MARK: - SHOW PREVIEW
#if DEBUG

import SwiftUI
struct CreateTracker_Preview: PreviewProvider {
    static var previews: some View {
        CreateTrackerViewController().showPreview()
    }
}
#endif
