//
//  OnboardingPageView.swift
//  Tracker
//
//  Created by Roman Romanov on 02.10.2024.
//

import UIKit

final class OnboardingPageView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: OnboardingPageViewDelegate?
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppColorSettings.onboardingFontColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var skipTourButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColorSettings.onboardingFontColor
        button.setTitle(Constants.onboardingSkipTourButton, for: .normal)
        button.setTitleColor(AppColorSettings.onboardingCellIconFontColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Init
    
    init(delegate: OnboardingPageViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupLayout()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingPageView {
    
    // MARK: - didTapButton
    
    private func setupButtons() {
        skipTourButton.addTarget(nil, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // MARK: - didTapButton
    
    @objc private func didTapButton() {
        delegate?.dismis()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubviews(
            backgroundImage,
            messageLabel,
            skipTourButton
        )
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: skipTourButton.topAnchor, constant: -160),
            messageLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            skipTourButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            skipTourButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            skipTourButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipTourButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func setupView(for page: OnboardingPage) {
        backgroundImage.image = UIImage(named: page.backGroundImageName)
        messageLabel.text = page.message
    }
}

// MARK: - Constants

private extension OnboardingPageView {
    enum Constants {
        static let onboardingSkipTourButton = NSLocalizedString("onboarding.screen.skipButton", comment: "")
    }
}
