//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ScheduleTableViewCell"
    
    weak var delegate: ScheduleViewControllerCellDelegate?
    
    private var weekday: WeekDay?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = AppColorSettings.switchBackgroundColor
        switchView.addTarget(self, action: #selector(didToggleSwitchView), for: .valueChanged)
        return switchView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = AppColorSettings.chosenItemBackgroundColor
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScheduleTableViewCell {
    
    // MARK: - setupLayout
    
    private func setupLayout() {
        [
            nameLabel,
            switchView,
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -83),
            
            switchView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - prepareForReuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        switchView.isOn = false
    }
    
    // MARK: - setupCell
    
    func setupCell(with model: WeekDayModel) {
        self.weekday = model.day
        nameLabel.text = model.day.description
        switchView.isOn = model.isSelected
    }
    
    // MARK: - didToggleSwitchView
    
    @objc private func didToggleSwitchView(_ sender: UISwitch) {
        guard let weekday else { return }
        delegate?.didToggleSwitchView(to: sender.isOn, of: weekday)
    }
}
