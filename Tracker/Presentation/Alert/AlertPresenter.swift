//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Roman Romanov on 07.10.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
        
    func callAlert(with model: AlertModel) {
        guard let delegate else { return }
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: model.buttonText, style: .destructive) { _ in
            if let completion = model.completion {
                completion()
            }
        }
        
        alert.addAction(action)
        
        if let cancelButtonText = model.cancelButtonText {
            let cancelAction = UIAlertAction(title: cancelButtonText, style: .cancel)
            alert.addAction(cancelAction)
            alert.preferredAction = cancelAction
        }
        
        alert.view.accessibilityIdentifier = "Alert"
        delegate.present(alert, animated: true, completion: nil)
    }
}
