//
//  editProfile.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A view for editing a user's profile information, such as full name or password.
///
/// - Purpose:
///   - Allows users to update their profile fields securely.
///   - Includes validation for password length and feedback for errors.
///
/// - Features:
///   - Toggle visibility for secure password input.
///   - Dynamic support for editing different fields (e.g., "Password", "Full Name").
///   - Inline error handling with an alert for validation or update failures.
///
/// - Parameters:
///   - value: The current value of the field being edited (bound to the parent view).
///   - label: The label of the field being edited (e.g., "Password", "Full Name").
///   - isSecure: A boolean indicating whether the field is secure (e.g., for passwords).
struct editProfile: View {
    /// The authentication view model managing user data and updates.
    @EnvironmentObject var authViewModel: AuthViewModel

    /// The current value of the field being edited, bound to the parent view.
    @Binding var value: String

    /// The label for the field being edited (e.g., "Password", "Full Name").
    let label: String

    /// Indicates whether the field is secure (e.g., for password input).
    let isSecure: Bool

    /// A dismiss action for closing the view.
    @Environment(\.dismiss) var dismiss

    /// A temporary value to store user input before saving changes.
    @State private var tempValue: String = ""

    /// Toggles password visibility for secure fields.
    @State private var isPasswordVisible = false

    /// Indicates whether an error alert should be displayed.
    @State private var showError = false

    /// The error message displayed in the alert.
    @State private var errorMessage = ""

    /// The body of the `editProfile` view.
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Input Field
                if isSecure {
                    HStack {
                        if isPasswordVisible {
                            // Plain text field for visible password
                            TextField("Enter new password", text: $tempValue)
                                .foregroundColor(.white)
                        } else {
                            // Secure text field for hidden password
                            SecureField("Enter new password", text: $tempValue)
                                .foregroundColor(.white)
                        }

                        // Toggle password visibility
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    .background(Color(hex: "2C2C2C"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow, lineWidth: 1)
                    )
                } else {
                    // Plain text field for non-secure fields
                    TextField("Enter new \(label.lowercased())", text: $tempValue)
                        .padding()
                        .background(Color(hex: "2C2C2C"))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.yellow, lineWidth: 1)
                        )
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Edit \(label)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.yellow),
                trailing: Button("Save") {
                    saveChanges()
                }
                .foregroundColor(.yellow)
                .disabled(tempValue.isEmpty || (isSecure && tempValue.count < 6)) // Validation
            )
            .background(Color(hex: "2C2C2C").ignoresSafeArea())
            .toolbarBackground(Color(hex: "2C2C2C"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit \(label)")
                        .foregroundColor(.yellow)
                        .font(.headline)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        .onAppear {
            tempValue = value
        }
    }

    /// Saves the changes made to the profile field.
    ///
    /// - Updates the password if the `label` is "Password".
    /// - Updates the user's full name if the `label` is "Full Name".
    /// - Displays an error message if the update fails.
    private func saveChanges() {
        if label == "Password" {
            authViewModel.updatePassword(tempValue) { success, errorMessage in
                DispatchQueue.main.async {
                    if success {
                        self.value = tempValue
                        self.dismiss()
                    } else {
                        self.errorMessage = errorMessage ?? "Failed to update password"
                        self.showError = true
                    }
                }
            }
        } else if label == "Full Name" {
            if var updatedUser = authViewModel.user {
                updatedUser.fullName = tempValue
                authViewModel.updateUserProfile(updatedUser)
                dismiss()
            }
        }
    }
}
