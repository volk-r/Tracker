//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 25.08.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    // MARK: PROPERTIES
    private lazy var statisticView = StatisticView()
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        view = statisticView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
}

extension StatisticViewController {
    // MARK: setupNavBar
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: SHOW PREVIEW
#if DEBUG

@available(iOS 17, *)
#Preview {
    StatisticViewController()
}

#endif
