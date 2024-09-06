//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    // MARK: - PROPERTIES
    static let identifier = "EmojiCollectionViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
        
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: FUNCTIONS
extension EmojiCollectionViewCell {
    func setupView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    func setupLayout() {
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: setupCell
    func setupCell(with label: String) {
        emojiLabel.text = label
    }
}
