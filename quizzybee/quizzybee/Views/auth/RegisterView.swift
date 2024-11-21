//
//  RegisterView.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/9/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var showError = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.ignoresSafeArea()

                TopShape()
                    .fill(Color.yellow)
                    .rotationEffect(.degrees(180))
                    .offset(y: -350)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer().frame(height: 100)
                    
                    Text("Register Today!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: -55)
                    
                    Spacer()
                    
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
                    
                    Button(action: {
                        registerUser()
                    }) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 50)
                    .padding(.top, 20)
                    
                    if showError, let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Already Registered?")
                        
                        NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                            Button(action: {
                                navigateToLogin = true
                            }) {
                                Text("Login")
                                    .foregroundColor(.yellow)
                                    .underline()
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Register User
    private func registerUser() {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
            authViewModel.errorMessage = "All fields are required."
            showError = true
            return
        }
        
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
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
