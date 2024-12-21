//
//  headerForDashboard.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A header component for the dashboard.
///
/// The header includes:
/// - A user profile image that navigates to the user's profile page when tapped.
/// - A greeting message with the user's name.
/// - A gear icon (`gearShape`) for accessing additional options.
///
/// - Features:
///   - Displays the user's profile image or a default image.
///   - Dynamically updates the user image when changed.
///   - Displays a personalized greeting if the user's name is available.
///   - Provides access to additional functionality through the gear icon.
struct headerForDashboard: View {
    /// The authentication view model, managing user data and authentication state.
    @EnvironmentObject var authViewModel: AuthViewModel

    /// A unique identifier to refresh the user image when it is updated.
    @State private var refreshID = UUID()

    /// The body of the header view.
    var body: some View {
        HStack {
            // User profile image with navigation to the profile page
            NavigationLink(destination: userProfileView().environmentObject(authViewModel)) {
                userImage(
                    size: 50,
                    imageName: authViewModel.user?.profileImage ?? "UserImage1"
                )
            }
            .buttonStyle(PlainButtonStyle())
            .id(refreshID) // Ensures the user image updates when the UUID changes
            
            Spacer()
            
            // Greeting message
            if let userName = authViewModel.user?.fullName, !userName.isEmpty {
                Text("Hello, \(displayedUserName(userName))!")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .bold()
            } else {
                Text("Hello, newbee!")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .bold()
            }
            
            Spacer()

            // Gear icon for additional options
            gearShape()
        }
        .padding(.horizontal, 16)
        .onAppear {
            // Observer to refresh the user image when updated
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("UserImageUpdated"),
                object: nil,
                queue: .main
            ) { _ in
                refreshID = UUID()
            }
        }
    }

    /// Extracts and returns the first name from a full name string.
    ///
    /// - Parameter fullName: The full name of the user.
    /// - Returns: The first name, or the full name if no spaces are found.
    private func displayedUserName(_ fullName: String) -> String {
        return fullName.components(separatedBy: " ").first ?? fullName
    }
}
