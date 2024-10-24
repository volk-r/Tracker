//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Roman Romanov on 06.09.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ColorCollectionViewCell"
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
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

// MARK: - Layout

private extension ColorCollectionViewCell {
    func setupView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func setupLayout() {
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),
        ])
    }
}

extension ColorCollectionViewCell {
    
    // MARK: - setupCell
    
    func setupCell(with color: UIColor) {
        colorView.backgroundColor = color
    }
}

// MARK: - ColorCollectionViewCell

extension ColorCollectionViewCell: CellSelectProtocol {
    func select() {
        contentView.layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
        contentView.layer.borderWidth = 3
    }
    
    func deselect() {
        contentView.layer.borderWidth = 0
    }
}
