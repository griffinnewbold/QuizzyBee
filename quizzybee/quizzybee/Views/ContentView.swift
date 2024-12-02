//
//  ContentView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI
import CoreData

/// The main entry view for the Quizzybee application.
///
/// - Purpose:
///   - Serves as the initial screen for the app.
///   - Determines whether to display the `dashboardView` or `LoginView` based on the user's authentication state.
struct ContentView: View {
    // MARK: - State Objects
    /// Monitors network connectivity throughout the app.
    @StateObject private var networkMonitor = NetworkMonitor()
    /// Manages the onboarding tour logic.
    @StateObject private var tourGuide = onboardingModel()
    /// Handles user authentication and related state management.
    @StateObject private var authViewModel = AuthViewModel()
    
    // MARK: - Body
    var body: some View {
        if authViewModel.user != nil {
            // Show the dashboard if the user is logged in
            dashboardView()
                .environmentObject(authViewModel)
                .environmentObject(networkMonitor)
                .environmentObject(tourGuide)
        } else {
            // Show the login view if the user is not logged in
            LoginView()
                .environmentObject(authViewModel)
                .environmentObject(networkMonitor)
                .environmentObject(tourGuide)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
