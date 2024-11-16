//
//  LoginView.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/9/24.
//

import SwiftUI

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

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var navigateToRegister = false
    @State private var navigateToDashboard = false

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
                    Spacer().frame(height: 80)
                    
                    Text("Login Today!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: -75)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "Email:", text: $email)
                        SecureField("Password:", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        loginUser()
                        print("the user has successfully logged in")
                    }) {
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
                    
                    // MARK: Nav to dashboard
                    NavigationLink(
                        destination: dashboardView()
                            .environmentObject(authViewModel),
                        isActive: $navigateToDashboard
                    ) {
                        EmptyView()
                    }
                    
                    if showError, let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Not Registered Yet?")
                        
                        NavigationLink(destination: RegisterView(), isActive: $navigateToRegister) {
                            Button(action: {
                                navigateToRegister = true
                            }) {
                                Text("Register")
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
    
    // MARK: - Login User by Calling AuthViewModel
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            authViewModel.errorMessage = "Please enter all fields."
            showError = true
            return
        }
        
        authViewModel.logIn(email: email, password: password)
        
        if let errorMessage = authViewModel.errorMessage {
            showError = true
            print("Error: \(errorMessage)")
        } else {
            showError = false
            navigateToDashboard = true
            email = ""
            password = ""
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
