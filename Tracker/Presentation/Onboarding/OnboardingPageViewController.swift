//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 01.10.2024.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var onboardingPageView = OnboardingPageView(delegate: self)
    private let pageNumber: OnboardingPage
    
    // MARK: - Init
    
    init(pageNumber: OnboardingPage) {
        self.pageNumber = pageNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = onboardingPageView
        onboardingPageView.setupView(for: pageNumber)
    }
}

extension OnboardingPageViewController: OnboardingPageViewDelegate {
    func dismis() {
        print("OnboardingPageViewController")
        dismiss(animated: true)
    }
}
