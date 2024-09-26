//
//  UIColorMarshalling.swift
//  Tracker
//
//  Created by Roman Romanov on 26.09.2024.
//

import UIKit

struct UIColorMarshalling {
    static func serialize(color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X%02X",
                      Int(r * 0xff),
                      Int(g * 0xff),
                      Int(b * 0xff),
                      Int(a * 0xff))
    }
    
    static func deserialize(hexString: String) -> UIColor? {
        let r, g, b, a: CGFloat
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
