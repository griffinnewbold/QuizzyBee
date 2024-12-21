//
//  RegisterView.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/9/24.
//

import SwiftUI

/// A view for user registration in the Quizzybee app.
struct RegisterView: View {
    // MARK: - Environment Objects
    /// The authentication view model responsible for handling user authentication logic.
    @StateObject private var authViewModel = AuthViewModel()
    /// An environment object to monitor network connectivity.
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    // MARK: - State Properties
    /// The user's full name input.
    @State private var fullName = ""
    /// The user's email input.
    @State private var email = ""
    /// The user's password input.
    @State private var password = ""
    /// A flag indicating whether to show an error message.
    @State private var showError = false
    /// A flag to navigate to the login view.
    @State private var navigateToLogin = false
    /// A flag to show a network connectivity alert.
    @State private var showNetworkAlert = false
    /// A flag indicating whether the user has given AI consent.
    @State private var aiConsentGiven = false

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.gray.ignoresSafeArea()
                TopShape()
                    .fill(Color.yellow)
                    .rotationEffect(.degrees(180))
                    .offset(y: -350)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer().frame(height: 100)
                    
                    // Header Text
                    Text("Register Today!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: -55)
                    
                    Spacer()
                    
                    // Input Fields
                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "Full Name:", text: $fullName)
                        CustomTextField(placeholder: "Email:", text: $email)
                        
                        SecureField("Password:", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 20)
                    
                    // AI Consent Notice with Checkbox
                    HStack {
                        Button(action: {
                            aiConsentGiven.toggle()
                        }) {
                            Image(systemName: aiConsentGiven ? "checkmark.square" : "square")
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text("I consent to the use of Generative AI in Quizzybee.")
                            .foregroundColor(.white)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 50)
                    .padding(.top, 10)
                    
                    // Register Button
                    Button(action: {
                        registerUser()
                    }) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(aiConsentGiven ? Color.yellow : Color(hex: "D3D3D3"))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .disabled(!aiConsentGiven) // Disable button until consent is given
                    .padding(.horizontal, 50)
                    .padding(.top, 20)
                    
                    // Error Message
                    if showError, let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    // Navigation to Login
                    HStack {
                        Text("Already Registered?")
                        
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            Text("Login")
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
            // Navigation Destination to Login
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Register User
    
    /// Handles user registration.
    ///
    /// - Requires:
    ///   - The `fullName`, `email`, and `password` fields must not be empty.
    /// - Action:
    ///   - Checks network connectivity.
    ///   - Calls the `signUp` method in the `AuthViewModel` to create a new user account.
    /// - Error Handling:
    ///   - If any field is empty, sets `authViewModel.errorMessage`.
    ///   - If the network is not connected, shows a network alert.
    private func registerUser() {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
            authViewModel.errorMessage = "All fields are required."
            showError = true
            return
        }
        
        if networkMonitor.isConnected {
            authViewModel.signUp(email: email, password: password, name: fullName) { success in
                if success {
                    showError = false
                    fullName = ""
                    email = ""
                    password = ""
                    navigateToLogin = true
                } else {
                    showError = true
                }
            }
        } else {
            showNetworkAlert = true
        }
    }
}

// MARK: - Previews

/// Previews for the `RegisterView`.
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(NetworkMonitor())
    }
}
