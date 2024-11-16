//
//  editProfileView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct editProfile: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var value: String
    let label: String
    let isSecure: Bool
    @Environment(\.dismiss) var dismiss
    @State private var tempValue: String = ""
    @State private var isPasswordVisible = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isSecure {
                    HStack {
                        if isPasswordVisible {
                            TextField("Enter new password", text: $tempValue)
                        } else {
                            SecureField("Enter new password", text: $tempValue)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    TextField("Enter new \(label.lowercased())", text: $tempValue)
                }
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .navigationTitle("Edit \(label)")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveChanges()
                }
                    // ensure password is >= 6 characters
                    .disabled(tempValue.isEmpty || (isSecure && tempValue.count < 6))
            )
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
    
    // MARK: Allow updates for username and password
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
