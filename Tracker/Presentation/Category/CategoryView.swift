//
//  CategoryView.swift
//  Tracker
//
//  Created by Roman Romanov on 05.10.2024.
//

import UIKit

final class CategoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CategoryViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.separatorColor = AppColorSettings.notActiveFontColor
        tableView.isEmptyHeaderHidden = true
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.addCategoryMessage, for: .normal)
        button.setTitleColor(AppColorSettings.backgroundColor, for: .normal)
        button.backgroundColor = AppColorSettings.fontColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var placeHolderView: UIView = DummyView(model: DummyPlaceHolder.categoryEmptyPage.model)
    
    // MARK: - Lifecycle
    
    init(delegate: CategoryViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = AppColorSettings.backgroundColor
        setupLayout()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryView {
    
    // MARK: - setupTableView
    
    func setupTableView(source: CategoryViewController) {
        tableView.delegate = source
        tableView.dataSource = source
        
        tableView.register(
            MainTableViewCell.self,
            forCellReuseIdentifier: MainTableViewCell.identifier
        )
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    // MARK: - showPlaceHolder
    
    func showPlaceHolder(isVisible: Bool) {
        placeHolderView.isHidden = isVisible
    }
    
    // MARK: - setupButtons
    
    private func setupButtons() {
        createButton.addTarget(self, action: #selector(createButtonTapAction), for: .touchUpInside)
    }
    
    // MARK: - createButtonTapAction
    
    @objc private func createButtonTapAction() {
        delegate?.tapCreateButton()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubviews(
            placeHolderView,
            tableView,
            createButton
        )
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            placeHolderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - Constants

private extension CategoryView {
    enum Constants {
        static let addCategoryMessage = NSLocalizedString("category.screen.addCategory", comment: "")
    }
}
