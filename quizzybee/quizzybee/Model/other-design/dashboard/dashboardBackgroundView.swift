//
//  dashboardBackgroundView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/11.
//

import SwiftUI

/// A custom background view for the dashboard with a grey base and yellow accents.
///
/// - Features:
///   - The background consists of a full-screen grey color.
///   - Two yellow triangular shapes are drawn:
///     - Top-left: Extends from the top to 40% of the screen height.
///     - Bottom-right: Extends from the bottom to 60% of the screen height.
///
/// - Styling:
///   - Grey color: Hex `7B7B7B`.
///   - Yellow accent: Hex `FFD000`.
struct dashboardBackgroundView: View {
    /// The body of the view, which defines the custom background.
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full-screen grey background
                Color(hex: "7B7B7B").ignoresSafeArea()
                
                // Yellow accent triangles
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    // Top-left triangle
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: 0, y: height * 0.4))
                    path.addLine(to: CGPoint(x: width * 0.7, y: 0))
                    path.closeSubpath()
                    
                    // Bottom-right triangle
                    path.move(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: width, y: height * 0.6))
                    path.addLine(to: CGPoint(x: width * 0.3, y: height))
                    path.closeSubpath()
                }
                .fill(Color(hex: "FFD000")) // Fills the triangles with yellow color
            }
        }
        .ignoresSafeArea() // Ensures the background extends beyond safe areas
    }
}
