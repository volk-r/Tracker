//
//  TrackerView.swift
//  Tracker
//
//  Created by Roman Romanov on 25.08.2024.
//

import UIKit

final class TrackerView: UIView {
    // MARK: PROPERTIES
    lazy var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: AppImages.addNewTracker)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = AppColorSettings.fontColor
        
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: Date())
        
        var dateComponents = DateComponents()
        dateComponents.year = components.year
        dateComponents.month = components.month
        dateComponents.day = components.day
        datePicker.date = calendar.date(from: dateComponents) ?? Date()

        return datePicker
    }()
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.textColor = AppColorSettings.fontColor
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = "Поиск"
        return textField
    }()
    
    lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        collectionViewLayout?.sectionHeadersPinToVisibleBounds = true
        
        return collectionView
    }()
    
    lazy var placeHolderView: UIView = DummyView(description: "Что будем отслеживать?", imageName: AppImages.trackerEmptyPage)
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setupLayout
    private func setupLayout() {
        [
            addButton,
            pageTitle,
            datePicker,
            searchTextField,
            trackerCollectionView,
            placeHolderView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            addButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 6),
            
            pageTitle.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            pageTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            datePicker.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            searchTextField.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            trackerCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            trackerCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            placeHolderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
