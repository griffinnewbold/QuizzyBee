//
//  gearShape.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A gear icon component for the dashboard header.
///
/// The gear icon provides access to:
/// - Re-starting the onboarding tour.
/// - Logging out of the application.
///
/// - Features:
///   - Tapping the gear icon reveals a menu with options.
///   - "Show Tour" allows the user to restart the onboarding process.
///   - "Log Out" logs the user out and navigates to the login view.
struct gearShape: View {
    /// The authentication view model, managing user authentication.
    @EnvironmentObject var authViewModel: AuthViewModel
    
    /// The onboarding model, managing onboarding steps and flow.
    @EnvironmentObject var tourGuide: onboardingModel
    
    /// A flag indicating whether the menu is shown.
    @State private var showMenu = false
    
    /// A flag indicating whether the user should navigate to the login view.
    @State private var shouldLogin = false

    /// The body of the view, containing the gear icon and menu options.
    var body: some View {
        ZStack {
            // Gear icon that toggles the menu
            Image("GearShape")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    showMenu.toggle()
                }
            
            // Menu options displayed when `showMenu` is true
            if showMenu {
                VStack(alignment: .leading, spacing: 12) {
                    // Option to restart the onboarding tour
                    Button(action: {
                        tourGuide.startTour(userID: authViewModel.user?.userID ?? "")
                        showMenu = false
                    }) {
                        Label("Show Tour", systemImage: "questionmark.circle")
                    }
                    
                    // Option to log out
                    Button(role: .destructive, action: {
                        authViewModel.logOut()
                        shouldLogin = true
                    }) {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .navigationDestination(isPresented: $shouldLogin) {
                        LoginView()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8)) // Semi-transparent background for the menu
                .cornerRadius(10)
                .shadow(radius: 5)
                .offset(x: -30, y: 80) // Position the menu below the gear icon
                .frame(width: 200)
                .fixedSize()
            }
        }
        .frame(width: 50, height: 50) // Gear icon frame
        .onTapGesture {
            showMenu = false // Hide menu when tapping outside
        }
    }
}
