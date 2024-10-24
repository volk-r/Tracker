//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TrackerCollectionViewCell"
    
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    private var tracker: Tracker?
    private var days = 0 {
        willSet {
            daysCountLabel.text = String.localizedStringWithFormat(
                Constants.numberOfDays,
                newValue
            )
        }
    }
    
    private let analyticService: AnalyticServiceProtocol = AnalyticService()
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderColor = AppColorSettings.notActiveFontColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let iconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = AppColorSettings.cellIconFontColor.withAlphaComponent(0.3)
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textColor = AppColorSettings.cellIconFontColor
        return label
    }()
    
    private let daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var addDayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = AppColorSettings.cellIconFontColor
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapAddDayButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var pinnedImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "pin.fill")
        imageView.isHidden = true
        return imageView
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

extension TrackerCollectionViewCell {
    
    // MARK: - prepareForReuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        days = 0
        addDayButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addDayButton.layer.opacity = 1
        pinnedImageView.isHidden = true
    }
    
    // MARK: - setupCell
    
    func setupCell(with tracker: Tracker, days: Int, isCompleted: Bool) {
        self.tracker = tracker
        self.days = days
        cardView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        trackerNameLabel.text = tracker.name
        addDayButton.backgroundColor = tracker.color
        setupAddDayButton(isCompleted: isCompleted)
        pinnedImageView.isHidden = !tracker.isPinned
    }
    
    // MARK: - setupAddDayButton
    
    func setupAddDayButton(isCompleted: Bool) {
        if isCompleted {
            addDayButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            addDayButton.layer.opacity = 0.3
        } else {
            addDayButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addDayButton.layer.opacity = 1
        }
    }
    
    // MARK: - increaseDayCount
    
    func increaseDayCount() {
        days += 1
    }
    
    // MARK: - decreaseDayCount
    
    func decreaseDayCount() {
        days -= 1
    }
    
    // MARK: - didTapAddDayButton
    
    @objc private func didTapAddDayButton() {
        analyticService.trackClick(screen: .main, item: .tapTracker)
        guard let tracker else { return }
        delegate?.didTapAddDayButton(for: tracker, in: self)
    }
    
    // MARK: - setupLayout
    
    private func setupLayout() {
        // card
        [
            iconView,
            emojiLabel,
            pinnedImageView,
            trackerNameLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        // cell
        [
            cardView,
            trackerNameLabel,
            daysCountLabel,
            addDayButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: Constants.cardViewHeight),
            
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.mainInset),
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.mainInset),
            iconView.widthAnchor.constraint(equalToConstant: Constants.viewWidth),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            
            pinnedImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.secondaryInset / 2),
            pinnedImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.mainInset),
            pinnedImageView.widthAnchor.constraint(equalToConstant: Constants.viewWidth),
            pinnedImageView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.mainInset),
            trackerNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.mainInset),
            trackerNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Constants.mainInset),
            
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.mainInset),
            daysCountLabel.centerYAnchor.constraint(equalTo: addDayButton.centerYAnchor),
            daysCountLabel.trailingAnchor.constraint(equalTo: addDayButton.leadingAnchor, constant: -Constants.secondaryInset),
            
            addDayButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Constants.secondaryInset),
            addDayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.mainInset),
            addDayButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            addDayButton.heightAnchor.constraint(equalTo: addDayButton.widthAnchor),
        ])
    }
}

// MARK: - Constants

private extension TrackerCollectionViewCell {
    enum Constants {
        static let numberOfDays = NSLocalizedString("numberOfDays", comment: "Number of completed habbits/events in days")
        
        static let cardViewHeight: CGFloat = 90
        static let mainInset: CGFloat = 12
        static let secondaryInset: CGFloat = 8
        static let viewWidth: CGFloat = 24
        static let buttonWidth: CGFloat = 34
    }
}
