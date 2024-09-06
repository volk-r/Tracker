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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создание трекера"
    }
}
