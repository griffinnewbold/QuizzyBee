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
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
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
                    print("login clicked \(email) and \(password) entered.")
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
                
                Spacer()
                
                HStack {
                    Text("Not Registered Yet?")
                    
                    Button(action: {
                        print("placehold navigate to register page")
                    }) {
                        Text("Register")
                            .foregroundColor(.yellow)
                            .underline()
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
