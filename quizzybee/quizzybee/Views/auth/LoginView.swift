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
    @State private var navigateToDashboard = false
    @State private var loggedInUser: User?

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
                    
                    if showError, let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
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
                
                // Navigation link to dashboard view
                NavigationLink(
                    destination: dashboardView(user: loggedInUser ?? User()),
                    isActive: $navigateToDashboard
                ) {
                    EmptyView()
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
        
        authViewModel.logIn(email: email, password: password) { user in
            if let user = user {
                self.loggedInUser = user
                self.navigateToDashboard = true
            } else {
                self.showError = true
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
