//
//  gearShape.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// gearShape on the dashboard header
/// has "show tour" and "log out" options
struct gearShape: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var tourGuide: onboardingModel
    @State private var showMenu = false
    @State private var shouldLogin = false
    
    
    var body: some View {
        ZStack {
            Image("GearShape")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    showMenu.toggle()
                }
            
            if showMenu {
                VStack(alignment: .leading, spacing: 12) {
                    // re-show tour
                    Button(action: {
                        tourGuide.startTour(userID: authViewModel.user?.userID ?? "")
                        showMenu = false
                    }) {
                        Label("Show Tour", systemImage: "questionmark.circle")
                    }
                    
                    Button(role: .destructive, action: {
                        authViewModel.logOut()
                        shouldLogin = true
                    }) {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .navigationDestination(isPresented: $shouldLogin) {
                        LoginView()
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
