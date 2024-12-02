//
//  highlightOverlay.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/29.
//

import SwiftUI

/// A view that highlights a specific rectangular portion of the screen while dimming the rest.
///
/// - Purpose:
///   - Draws attention to a specified area by dimming the surrounding background.
///   - Displays a rectangular highlight with a white border around the specified `frame`.
///
/// - Features:
///   - A semi-transparent black overlay dims the entire screen except for the highlighted area.
///   - The highlighted area is visually emphasized with a white border.
///
/// - Parameters:
///   - frame: The `CGRect` defining the portion of the screen to highlight.
struct highlightOverlay: View {
    /// The frame specifying the area to highlight.
    let frame: CGRect

    /// The body of the highlight overlay.
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dimmed background
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        // Transparent rectangle over the specified frame
                        Rectangle()
                            .path(in: CGRect(origin: .zero, size: geometry.size))
                            .fill(Color.black.opacity(0.6))
                            .background(
                                Color.clear
                                    .frame(width: frame.width, height: frame.height)
                                    .position(x: frame.midX, y: frame.midY)
                            )
                            .blendMode(.destinationOut) // Combines layers to "cut out" the highlighted area
                    )
                    .compositingGroup() // Ensures proper rendering of the blend mode

                // Highlight border
                Rectangle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: frame.width, height: frame.height)
                    .position(x: frame.midX, y: frame.midY)
            }
        }
        .ignoresSafeArea() // Ensures the overlay covers the entire screen
    }
}
