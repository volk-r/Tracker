//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 25.08.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    private let trackerVC = TrackerViewController()
    private let statisticVC = StatisticViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
    }
    
    private func setupControllers() {
        let navigationControllerTracker = UINavigationController(rootViewController: trackerVC)
        let navigationControllerStatistic = UINavigationController(rootViewController: statisticVC)
        
        statisticVC.tabBarItem.image = UIImage(systemName: "hare.fill")
        statisticVC.title = "Статистика"
        trackerVC.tabBarItem.image = UIImage(systemName: "record.circle.fill")
        trackerVC.title = "Трекеры"
        
        viewControllers = [navigationControllerTracker, navigationControllerStatistic]
    }
}
