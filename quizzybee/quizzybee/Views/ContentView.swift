//
//  ContentView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject private var tourGuide = onboardingModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.user != nil {
            dashboardView()
                .environmentObject(authViewModel)
                .environmentObject(networkMonitor)
                .environmentObject(tourGuide)
        } else {
            LoginView()
                .environmentObject(authViewModel)
                .environmentObject(networkMonitor)
                .environmentObject(tourGuide)
        }
    }
}

#Preview {
    ContentView()
}
