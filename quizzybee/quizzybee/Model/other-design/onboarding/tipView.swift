//
//  tipView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/29.
//

import SwiftUI

/// A view that displays onboarding tips with a highlighted focus area.
///
/// - Purpose:
///   - Guides users through the onboarding steps.
///   - Highlights the current focus area and provides actionable buttons for navigation.
///
/// - Features:
///   - Dynamically positions the tip content above or below the highlight area based on the screen layout.
///   - Includes "Skip" and "Next" buttons for user control over the onboarding flow.
///
/// - Parameters:
///   - currentStep: The current step of the onboarding process, containing the highlight frame and instructional message.
///   - nextStep: A closure executed when the user presses the "Next" button.
///   - skipTour: A closure executed when the user presses the "Skip" button.
struct tipView: View {
    /// The current step of the onboarding process, including its message and highlight frame.
    let currentStep: onboardingModel.TourStep
    
    /// Closure to execute when the user navigates to the next step.
    let nextStep: () -> Void
    
    /// Closure to execute when the user skips the onboarding tour.
    let skipTour: () -> Void

    /// Determines whether the tip content should appear above or below the highlight area.
    var tipOnTop: Bool {
        let screenHeight = UIScreen.main.bounds.height
        return currentStep.highlightFrame.midY > screenHeight / 2
    }

    /// The body of the onboarding tip view.
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            // Highlight overlay for the current step's focus area
            highlightOverlay(frame: currentStep.highlightFrame)
            
            VStack {
                if tipOnTop {
                    // Tip content appears above the highlight area
                    VStack(spacing: 16) {
                        tipContent
                    }
                    .padding()
                    .background(Color.black.opacity(0.8)) // Semi-transparent black background
                    .cornerRadius(12)
                    .padding()
                    
                    Spacer()
                } else {
                    Spacer()
                    
                    // Tip content appears below the highlight area
                    VStack(spacing: 16) {
                        tipContent
                    }
                    .padding()
                    .background(Color.black.opacity(0.8)) // Semi-transparent black background
                    .cornerRadius(12)
                    .padding()
                }
            }
        }
    }
    
    /// The content of the tip, including the instructional message and buttons.
    private var tipContent: some View {
        VStack(spacing: 16) {
            // Instructional message
            Text(currentStep.message)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            
            // Action buttons
            HStack {
                // Skip button
                Button(action: skipTour) {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                
                // Next button
                Button(action: nextStep) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
    }
}
