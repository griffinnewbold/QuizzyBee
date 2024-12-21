//
//  pulseAnimation.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import Foundation
import SwiftUI

/// A view modifier that adds a pulsing animation effect to a view.
///
/// - Purpose:
///   - Creates a visual effect to draw the user's attention to an element.
///   - The animation scales the view and adjusts its opacity in a continuous loop.
///
/// - Features:
///   - Scales the view from its original size to double the size.
///   - Adjusts the opacity to create a fading effect.
///   - Runs the animation indefinitely with a smooth ease-in-out transition.
///
/// - Usage:
///   Apply `.modifier(pulseAnimation())` to any `View` to add the effect.
struct pulseAnimation: ViewModifier {
    /// The current scale of the view, which is animated.
    @State private var scale: CGFloat = 1

    /// Defines the body of the modified view.
    ///
    /// - Parameter content: The original view to apply the animation to.
    /// - Returns: A view with the pulsing animation effect applied.
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale) // Scales the view
            .opacity(2 - scale) // Adjusts the opacity inversely to the scale
            .onAppear {
                // Begins the pulsing animation when the view appears
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                    scale = 2
                }
            }
    }
}
