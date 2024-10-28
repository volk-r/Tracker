//
//  DummyView.swift
//  Tracker
//
//  Created by Roman Romanov on 26.08.2024.
//

import UIKit

final class DummyView: UIView {
    
    // MARK: - Properties
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - Init
    
    init(model: DummyModel) {
        super.init(frame: .zero)
        self.descriptionLabel.text = model.description
        self.descriptionImage.image = UIImage(named: model.imageName)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension DummyView {
    
    func setupNewModel(model: DummyModel) {
        descriptionLabel.text = model.description
        descriptionImage.image = UIImage(named: model.imageName)
    }
    
    private func setupLayout() {
        addSubviews(
            descriptionLabel,
            descriptionImage
        )
        
        NSLayoutConstraint.activate([
            descriptionImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionImage.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
