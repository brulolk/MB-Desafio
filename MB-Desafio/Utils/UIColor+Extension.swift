//
//  UIColor+App.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import UIKit

extension UIColor {
    
    // MARK: - Brand Colors
    static let customOrange = UIColor(hex: "#F85600")
    static let customBackground = UIColor(hex: "#0D0D0D")
    static let customCardBackground = UIColor(hex: "#1D1D1E")
    static let customGreen = UIColor(hex: "#00C853")
    static let customRed = UIColor(hex: "#FF3D00")
    
    // MARK: - Hex Initializer
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(white: 0, alpha: alpha) // Fallback cor preta
            return
        }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
        }

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
