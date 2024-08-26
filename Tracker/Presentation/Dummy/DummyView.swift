//
//  DummyView.swift
//  Tracker
//
//  Created by Roman Romanov on 26.08.2024.
//

import UIKit

final class DummyView: UIView {
    // MARK: PROPERTIES
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: Init
    init(description: String, imageName: String) {
        super.init(frame: .zero)
        self.descriptionLabel.text  = description
        self.descriptionImage.image = UIImage(named: imageName)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setupLayout
    private func setupLayout() {
        [
            descriptionLabel,
            descriptionImage
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            descriptionImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionImage.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
