//
//  profileList.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A view that displays and manages the user's profile information.
///
/// - Purpose:
///   - Allows users to view and edit profile details such as their full name and password.
///   - Provides non-editable fields for the user ID and email.
///   - Includes a copy-to-clipboard button for the user ID field.
///
/// - Features:
///   - Dynamic profile fields with bindings for editing.
///   - Secure input for the password field.
///   - Custom styling to match the application's design theme.
struct profileList: View {
    /// The authentication view model, managing user profile data.
    @EnvironmentObject var authViewModel: AuthViewModel

    /// A state variable to temporarily store the user's password for editing.
    @State private var currentPassword: String = "******"

    /// The body of the profile list view.
    var body: some View {
        VStack(spacing: 20) {
            // User ID Field (Non-editable with Copy Button)
            userIDRow(
                label: "User ID",
                value: authViewModel.user?.userID ?? ""
            )
            .background(Color(hex: "2C2C2C"))
            .cornerRadius(12)
            .padding(.horizontal, 16)

            // Full Name Field (Editable)
            profileRow(
                label: "Full Name",
                value: Binding(
                    get: { authViewModel.user?.fullName ?? "" },
                    set: { newValue in
                        if var updatedUser = authViewModel.user {
                            updatedUser.fullName = newValue
                            authViewModel.updateUserProfile(updatedUser)
                        }
                    }
                )
            )
            .background(Color(hex: "2C2C2C"))
            .cornerRadius(12)
            .padding(.horizontal, 16)

            // Email Field (Non-editable)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .foregroundColor(.yellow)
                        .font(.system(size: 14, weight: .bold))
                    
                    Text(authViewModel.user?.email ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "2C2C2C"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 16)

            // Password Field (Editable)
            profileRow(label: "Password", value: $currentPassword, isSecure: true)
                .background(Color(hex: "2C2C2C"))
                .cornerRadius(12)
                .padding(.horizontal, 16)

        }
        .padding(.vertical, 16)
        .background(Color(hex: "2C2C2C").ignoresSafeArea()) // Matches main view background
    }
}

/// A row component for displaying the user ID with a copy-to-clipboard button.
///
/// - Parameters:
///   - label: The label for the field (e.g., "User ID").
///   - value: The value to display and copy (e.g., the user ID).
struct userIDRow: View {
    /// The label for the field (e.g., "User ID").
    let label: String
    
    /// The value to display and copy (e.g., the user ID).
    let value: String

    /// The body of the user ID row view.
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                // Field label
                Text(label)
                    .foregroundColor(.yellow)
                    .font(.system(size: 14, weight: .bold))
                
                // Field value
                Text(value)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer()

            // Copy-to-clipboard button
            Button(action: {
                UIPasteboard.general.string = value
            }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.yellow)
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "2C2C2C")) // Dark gray background
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow, lineWidth: 1) // Yellow border
                )
        )
        .padding(.horizontal, 16)
    }
}
