//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Roman Romanov on 22.08.2024.
//

import UIKit

class TrackerViewController: UIViewController {
    // MARK: PROPERTIES
    private lazy var trackerView = TrackerView()
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: Lifestyle
    override func loadView() {
        super.loadView()
        view = trackerView
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupButtons()
    }
}

extension TrackerViewController {
    // MARK: setupCollectionView
    private func setupCollectionView() {
        trackerView.trackerCollectionView.dataSource = self
        trackerView.trackerCollectionView.delegate = self
        trackerView.trackerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: setupButtons
    private func setupButtons() {
        trackerView.addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
    
    @objc private func addAction() {
        print("clicked")
    }
}

// MARK: UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
}
