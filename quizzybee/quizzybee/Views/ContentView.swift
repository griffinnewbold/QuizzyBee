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
    
    var body: some View {
        LoginView()
            .environmentObject(networkMonitor)
    }
}

#Preview {
    ContentView()
}
