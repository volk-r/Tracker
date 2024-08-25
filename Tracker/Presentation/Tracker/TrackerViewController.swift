//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 22.08.2024.
//

import UIKit

class TrackerViewController: UIViewController {
    // MARK: PROPERTIES
    private lazy var trackerView = TrackerView()
    
    // MARK: Lifestyle
    override func loadView() {
        super.loadView()
        view = trackerView
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
}

extension TrackerViewController {
    // MARK: setupButtons
    private func setupButtons() {
        trackerView.addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
    
    @objc private func addAction() {
        print("clicked")
    }
}

