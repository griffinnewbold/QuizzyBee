//
//  editProfile.swift
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
                // Input Field
                if isSecure {
                    HStack {
                        if isPasswordVisible {
                            TextField("Enter new password", text: $tempValue)
                                .foregroundColor(.white)
                        } else {
                            SecureField("Enter new password", text: $tempValue)
                                .foregroundColor(.white)
                        }

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
                .disabled(tempValue.isEmpty || (isSecure && tempValue.count < 6))
            )
            .background(Color(hex: "2C2C2C").ignoresSafeArea())
            .toolbarBackground(Color(hex: "2C2C2C"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit \(label)")
                        .foregroundColor(.yellow) // Yellow navigation title
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
