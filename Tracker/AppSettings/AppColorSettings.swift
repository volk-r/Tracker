//
//  AppColorSettings.swift
//  Tracker
//
//  Created by Roman Romanov on 24.08.2024.
//

import UIKit

enum AppColorSettings {
    static let switchBackgroundColor = UIColor(hexString: "#3772E7")
    
    static let backgroundColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor(hexString: "#1A1B22") : UIColor(hexString: "#FFFFFF")
    }
    
    static let fontColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#1A1B22")
    }
    
    static let onboardingFontColor = UIColor(hexString: "#1A1B22")
    static let onboardingCellIconFontColor = UIColor(hexString: "#FFFFFF")
    
    static let cellIconFontColor = UIColor(hexString: "#FFFFFF")
    static let notActiveFontColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor(hexString: "#AEAFB4") : UIColor(hexString: "#AEAFB4")
    }

    static let redColor = UIColor(hexString: "#F56B6C")

    static let chosenItemBackgroundColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor(hexString: "#414141") : UIColor(hexString: "#E6E8EB").withAlphaComponent(0.3)
    }
    
    static let chosenEmojiItemBackgroundColor = UIColor(hexString: "#E6E8EB")
    
    static let filterButtonBackgroundColor = UIColor(hexString: "#3772E7")
    static let filterButtonFontColor = UIColor(hexString: "#FFFFFF")
    static let filterButtonFontColorActive = UIColor(hexString: "#FFFF00")
    
    static let palette: [UIColor] = [
        UIColor(hexString: "#FD4C49"),
        UIColor(hexString: "#FF881E"),
        UIColor(hexString: "#007BFA"),
        UIColor(hexString: "#6E44FE"),
        UIColor(hexString: "#33CF69"),
        UIColor(hexString: "#E66DD4"),
        UIColor(hexString: "#F9D4D4"),
        UIColor(hexString: "#34A7FE"),
        UIColor(hexString: "#46E69D"),
        UIColor(hexString: "#35347C"),
        UIColor(hexString: "#FF674D"),
        UIColor(hexString: "#FF99CC"),
        UIColor(hexString: "#F6C48B"),
        UIColor(hexString: "#7994F5"),
        UIColor(hexString: "#832CF1"),
        UIColor(hexString: "#AD56DA"),
        UIColor(hexString: "#8D72E6"),
        UIColor(hexString: "#2FD058"),
    ]
}
