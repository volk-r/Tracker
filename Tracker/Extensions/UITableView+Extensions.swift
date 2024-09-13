//
//  UITableView+Extensions.swift
//  Tracker
//
//  Created by Roman Romanov on 08.09.2024.
//

import UIKit

extension UITableView {

  @IBInspectable
  var isEmptyHeaderHidden: Bool {
        get {
          return tableHeaderView != nil
        }
        set {
          if newValue {
              tableHeaderView = UIView(frame: .zero)
          } else {
              tableHeaderView = nil
          }
       }
    }
}
