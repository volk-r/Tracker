//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Roman Romanov on 02.10.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
