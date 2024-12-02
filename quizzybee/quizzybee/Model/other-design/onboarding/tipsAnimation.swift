//
//  tips.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import SwiftUI

/// A view that guides users to navigate into a detailed deck view by highlighting a target area.
///
/// - Purpose:
///   - Draws user attention to a specific portion of the screen using a highlight and a message.
///   - Provides an option to skip the guide via a close button.
///
/// - Features:
///   - Dimmed background to focus attention on the target area.
///   - Highlighted target area with a pulsing animation to guide the user.
///   - A customizable message positioned near the highlighted area.
///   - A skip button to exit the guide.
///
/// - Parameters:
///   - message: The instructional message to display.
///   - targetFrame: The frame of the area to highlight.
///   - onSkip: A closure executed when the user taps the skip button.
struct tipsAnimation: View {
    /// The instructional message displayed near the highlighted area.
    let message: String
    
    /// The frame of the target area to highlight.
    let targetFrame: CGRect
    
    /// Closure to execute when the user skips the guide.
    let onSkip: () -> Void

    /// The body of the guide view.
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .allowsHitTesting(false) // Prevents interaction with the dimmed area
            
            // Highlight area with cutout
            Path { path in
                // Full screen path
                path.addRect(CGRect(origin: .zero, size: UIScreen.main.bounds.size))
                // Cutout for the target frame
                path.addRoundedRect(in: targetFrame, cornerSize: CGSize(width: 8, height: 8))
            }
            .fill(style: FillStyle(eoFill: true)) // Use even-odd fill style to create the cutout
            
            // Guide message and close button
            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: onSkip) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
                .padding(.top, 8)
                
                // Instructional message
                Text(message)
                    .font(.subheadline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .position(x: targetFrame.midX, y: targetFrame.maxY + 50) // Position message below the target frame
            
            // Pulsing circle around the highlighted target area
            Circle()
                .stroke(Color.yellow, lineWidth: 2)
                .frame(width: 30, height: 30)
                .position(x: targetFrame.midX, y: targetFrame.midY)
                .modifier(pulseAnimation()) // Adds a pulsing animation
        }
    }
}
