//
//  quizzybeeApp.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/10/28.
//

import SwiftUI

@main
struct quizzybeeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
