//
//  NewTrackerTableViewCell.swift
//  Tracker
//
//  Created by Roman Romanov on 07.09.2024.
//

import UIKit

final class NewTrackerTableViewCell: UITableViewCell {
    // MARK: - PROPERTIES
    static let identifier = "NewTrackerTableViewCell"
       
    private var indexPathCell = IndexPath()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColorSettings.notActiveFontColor
        label.numberOfLines = 0
        return label
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let chooseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.right")
        button.setImage(image, for: .normal)
        button.tintColor = AppColorSettings.notActiveFontColor
        return button
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = AppColorSettings.chosenItemBackgroundColor.withAlphaComponent(0.3)
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewTrackerTableViewCell {
    // MARK: - SETUP LAYOUT
    private func setupLayout() {
        [
            nameLabel,
            descriptionLabel,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            labelsStack.addArrangedSubview($0)
        }
        
        [
            labelsStack,
            chooseButton,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56),
            labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            chooseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            chooseButton.widthAnchor.constraint(equalToConstant: 24),
            chooseButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    // MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
        chooseButton.imageView?.image = nil
    }
    
    // MARK: setupCell
    func setupCell(title: String, description: String?) {
        nameLabel.text = title
        descriptionLabel.text = description
    }
}
