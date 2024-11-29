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
    
    var body: some View {
        LoginView()
            .environmentObject(networkMonitor)
            .environmentObject(tourGuide)
    }
}

#Preview {
    ContentView()
}
