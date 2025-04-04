//
//  TrackerCollectionViewHeader.swift
//  Tracker
//
//  Created by Roman Romanov on 09.09.2024.
//

import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "TrackerCollectionViewHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackerCollectionViewHeader {
    
    // MARK: - setupHeaderCell
    
    func setupHeaderCell(with label: String) {
        titleLabel.text = label
    }
    
    // MARK: - setupLayout
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
