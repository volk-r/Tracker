//
//  StatisticCollectionViewCell.swift
//  Tracker
//
//  Created by Roman Romanov on 21.10.2024.
//

import UIKit

final class StatisticCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "StatisticCollectionViewCell"
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 7
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = AppColorSettings.fontColor
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = AppColorSettings.fontColor
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = AppColorSettings.backgroundColor
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        setupBorder()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatisticCollectionViewCell {
    
    // MARK: - setupCell
    
    func setupCell(with data: StatisticModel) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }
    
    // MARK: - setupBorder
    
    func setupBorder() {
        gradientBorder(
            width: 1,
            colors: [.blue, .green, .red],
            startPoint: .unitCoordinate(.left),
            endPoint: .unitCoordinate(.right),
            andRoundCornersWithRadius: 12
        )
    }
    
    // MARK: - setGradientBackground
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red, UIColor.green, UIColor.blue]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 361, height: 90)
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - setupLayout
    
    private func setupLayout() {
        // body
        [
            titleLabel,
            descriptionLabel,
        ].forEach {
            mainStackView.addArrangedSubview($0)
        }
        // main elements
        [mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
    }
}