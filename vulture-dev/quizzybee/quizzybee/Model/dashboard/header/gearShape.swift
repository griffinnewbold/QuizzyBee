//
//  gearShape.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct gearShape: View {
    @AppStorage("allow AI") var allowAI = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showMenu = false
    
    
    var body: some View {
        ZStack {
            //dashboardBackgroundView()
            
            Image("GearShape")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    showMenu.toggle()
                }
            
            if showMenu {
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        allowAI.toggle() // sync with profile
                    }) {
                        Label(
                            allowAI ? "AI is Enabled" : "AI is Disabled",
                            systemImage: allowAI ? "checkmark.circle.fill" : "circle"
                        )
                    }
                    
                    NavigationLink(destination: LoginView()) {
                        Label("Sign In", systemImage: "person.fill")
                            .foregroundColor(.black)
                    }
                    
                    Button(role: .destructive, action: {
                        authViewModel.logOut()
                    }) {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 5)
                .offset(x: -30, y: 80)
                .frame(width: 200)
                .fixedSize()
            }
        }
        .frame(width: 50, height: 50)
        .onTapGesture {
            showMenu = false
        }
    }
}

//#Preview {
//    gearShape().environmentObject(AuthViewModel())
//}
