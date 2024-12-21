//
//  ColorToHex.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/7.
//

import SwiftUI

/// Extension to the `Color` struct that provides utilities for working with hexadecimal colors.
extension Color {
    /// Initializes a `Color` instance from a hexadecimal color code.
    ///
    /// - Parameters:
    ///   - hex: A hexadecimal string representing the color. The string can be in the formats:
    ///     - RGB (e.g., "FFF" for white, shorthand)
    ///     - RGB (e.g., "FFFFFF" for white)
    ///     - ARGB (e.g., "FFFFFFFF" with alpha)
    ///
    /// - Note:
    ///   - Invalid input defaults to a transparent color (`r = 1, g = 1, b = 1, a = 0`).
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Converts a `Color` instance to its hexadecimal string representation.
    ///
    /// - Returns: A string in the format `#RRGGBB` or `nil` if the conversion fails.
    func toHex() -> String? {
        guard let components = cgColor?.components, components.count >= 3 else { return nil }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02lX%02lX%02lX",
                      lround(Double(r * 255)),
                      lround(Double(g * 255)),
                      lround(Double(b * 255)))
    }
    
    /// Determines whether the color is dark based on its perceived brightness.
    ///
    /// - Returns: `true` if the color is considered a dark background, otherwise `false`.
    ///
    /// - Note:
    ///   - The brightness is calculated using the formula:
    ///     \( \text{Brightness} = 0.299 \cdot R + 0.587 \cdot G + 0.114 \cdot B \)
    func isDarkBackground() -> Bool {
        // Convert Color to UIColor to extract RGB components
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate perceived brightness
        let brightness = (0.299 * red + 0.587 * green + 0.114 * blue)
        return brightness < 0.5 // Adjust threshold as needed
    }
}
