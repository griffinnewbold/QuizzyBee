//
//  RegisterView.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/9/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var fullName = ""
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
                    print("Clicked Register")
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
                
                Spacer()
                
                HStack {
                    Text("Already Registered?")
                    
                    Button(action: {
                        print("placehold navigate to login page")
                    }) {
                        Text("Login")
                            .foregroundColor(.yellow)
                            .underline()
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
