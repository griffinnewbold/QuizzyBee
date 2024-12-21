//
//  welcome.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import SwiftUI

/// A view that displays welcome and ending messages for the user onboarding tour.
///
/// - Purpose:
///   - Provides users with an introduction or conclusion message during the onboarding process.
///   - Includes a button to proceed to the next step or complete the tour.
///
/// - Features:
///   - Dynamically displays a welcome or ending message based on the `mode`.
///   - Includes a close button to skip the onboarding process.
///   - Displays a customizable action button to continue the onboarding flow.
///
/// - Parameters:
///   - mode: Determines whether the view displays the "welcome" or "ending" message.
///   - button: The label for the action button.
struct welcomeAndEnding: View {
    /// The onboarding model, managing the onboarding flow and steps.
    @EnvironmentObject var tourGuide: onboardingModel
    
    /// The authentication view model, providing user-related data and functionality.
    @EnvironmentObject var authViewModel: AuthViewModel
    
    /// The current mode, either "welcome" or "ending".
    let mode: String
    
    /// The label for the action button.
    let button: String

    /// The body of the welcome and ending view.
    var body: some View {
        VStack(spacing: 20) {
            // Close button to skip the tour
            HStack {
                Spacer()
                Button(action: {
                    if let userID = authViewModel.user?.userID {
                        tourGuide.skipTour(userID: userID)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
            .padding(.top, 8)
            
            // Display the appropriate message based on the mode
            if mode == "welcome" {
                Text(onboardingModel.TourStep.welcome.message)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            } else if mode == "ending" {
                Text(onboardingModel.TourStep.ending.message)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            
            // Action button to continue the onboarding flow
            Button("\(button)") {
                if let userID = authViewModel.user?.userID {
                    tourGuide.nextStep(userID: userID)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .padding(.vertical, 6)
            .background(Color(hex: "FFD000").opacity(0.7)) // Yellow background
            .foregroundColor(.black) // Black text
            .cornerRadius(8)
            .padding(.bottom, 10)
        }
        .background(Color.white.opacity(0.7)) // Semi-transparent white background
        .cornerRadius(12) // Rounded corners
        .shadow(radius: 5) // Subtle shadow effect
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .padding(.horizontal)
    }
}
