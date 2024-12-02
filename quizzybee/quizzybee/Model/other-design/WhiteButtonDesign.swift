//
//  WhiteButtonDesign.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import Foundation
import SwiftUI

/// A custom button style that applies a white background with rounded corners and a shadow.
///
/// - Purpose:
///   - Provides a consistent button design with a clean, modern look.
///   - Adds a subtle scaling effect when the button is pressed.
///
/// - Features:
///   - White background with rounded corners and a shadow for depth.
///   - Blue text for the button label.
///   - Responsive scaling effect when the button is pressed.
struct WhiteButtonDesign: ButtonStyle {
    /// Creates the button's visual appearance.
    ///
    /// - Parameter configuration: The configuration for the button, including its label and pressed state.
    /// - Returns: A styled view for the button.
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16)) // Sets the font size of the button label
            .foregroundColor(.blue) // Blue text color
            .frame(maxWidth: .infinity) // Makes the button stretch to the maximum width
            .padding() // Adds padding inside the button
            .background(
                RoundedRectangle(cornerRadius: 20) // Rounded rectangle background
                    .fill(Color.white) // White fill color
                    .shadow(radius: 2) // Subtle shadow for depth
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Adds a scaling effect when pressed
    }
}
