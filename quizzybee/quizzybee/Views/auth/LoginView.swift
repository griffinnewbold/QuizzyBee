//
//  LoginView.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/9/24.
//

import SwiftUI
import Foundation

/// A custom shape for the top decorative background.
struct TopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

/// The primary view for user login.
struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()  // ViewModel for handling authentication logic.
    @EnvironmentObject var networkMonitor: NetworkMonitor    // Observes network connectivity.
    @State private var email = ""                            // User's email input.
    @State private var password = ""                         // User's password input.
    @State private var showError = false                     // Flag to control error message visibility.
    @State private var showNetworkAlert = false              // Flag to display network alert.
    @State private var navigateToDashboard = false           // Flag to navigate to the dashboard.
    @State private var showResetPasswordSheet = false        // Flag to show password reset sheet.

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.ignoresSafeArea()
                TopShape()
                    .fill(Color.yellow)
                    .rotationEffect(.degrees(180))
                    .offset(y: -350)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer().frame(height: 80)
                    
                    // Header Text
                    Text("Login Today!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: -75)
                    
                    Spacer()
                    
                    // Input Fields
                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "Email:", text: $email)
                        SecureField("Password:", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 20)
                    
                    // Login Button
                    Button(action: loginUser) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 50)
                    .padding(.top, 20)
                    
                    // Error Message
                    if showError, let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.black)
                            .padding(.top, 10)
                            .bold()
                    }
                    
                    // Forgot Password Link
                    Button(action: {
                        showResetPasswordSheet.toggle()
                    }) {
                        HStack {
                            Text("Forgot Your Password?")
                                .foregroundColor(.black)
                            Text("Reset It")
                                .foregroundColor(.yellow)
                                .underline()
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Navigation to Register View
                    HStack {
                        Text("Not Registered Yet?")
                        NavigationLink(destination: RegisterView()) {
                            Text("Register")
                                .foregroundColor(.yellow)
                                .underline()
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            // Network Error Alert
            .alert("Network Error", isPresented: $showNetworkAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("There is a network issue. Please try again later.")
            }
            // Navigation to Dashboard
            .navigationDestination(isPresented: $navigateToDashboard) {
                dashboardView()
                    .environmentObject(authViewModel)
                    .environmentObject(networkMonitor)
            }
            // Reset Password Sheet
            .sheet(isPresented: $showResetPasswordSheet) {
                ResetPasswordView()
                    .environmentObject(authViewModel)
                    .environmentObject(networkMonitor)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    /// Handles the user login process.
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            authViewModel.errorMessage = "Please enter all fields."
            showError = true
            return
        }
        
        if networkMonitor.isConnected {
            authViewModel.logIn(email: email, password: password) { user in
                if user != nil {
                    self.navigateToDashboard = true
                } else {
                    self.showError = true
                }
            }
        } else {
            showNetworkAlert = true
        }
    }
}

/// The view for resetting a user's password.
struct ResetPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel    // ViewModel for authentication.
    @EnvironmentObject var networkMonitor: NetworkMonitor // Observes network connectivity.
    @Environment(\.dismiss) private var dismiss           // Dismisses the sheet.
    @State private var email = ""                         // User's email input for reset.
    @State private var showError = false                  // Flag to display error messages.
    @State private var showNetworkAlert = false           // Flag to display network error alert.

    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            VStack {
                // Back Button and Title
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.yellow)
                            .padding()
                    }
                    Spacer()
                    Text("Reset Password")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: -60)
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                Spacer().frame(height: 40)
                
                Spacer()
                
                // Email Input
                CustomTextField(placeholder: "Enter your email:", text: $email)
                    .padding(.horizontal, 20)
                
                // Reset Password Button
                Button(action: resetPassword) {
                    Text("Reset Password")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 50)
                .padding(.top, 20)
                
                // Error Message
                if showError, let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
        }
    }

    /// Handles the password reset process.
    private func resetPassword() {
        guard !email.isEmpty else {
            authViewModel.errorMessage = "Please enter your email."
            showError = true
            return
        }
        
        if networkMonitor.isConnected {
            authViewModel.resetPassword(email: email) { success, _ in
                if success {
                    authViewModel.errorMessage = "Password reset email sent."
                } else {
                    authViewModel.errorMessage = "Error sending reset email. Please try again."
                }
                showError = true
            }
        } else {
            showNetworkAlert = true
        }
    }
}

/// Previews for the `LoginView`.
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(NetworkMonitor())
    }
}
