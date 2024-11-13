//
//  quizzybeeApp.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI
import Firebase

@main
struct quizzybeeApp: App {
    
    //sets up firebase to be used
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
