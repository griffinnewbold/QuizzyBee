//
//  quizzybeeApp.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI
import Firebase
import UserNotifications

/// The entry point for the Quizzybee application.
@main
struct quizzybeeApp: App {
    /// The application delegate instance to manage app lifecycle events.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Observes network connectivity changes.
    @StateObject private var networkMonitor = NetworkMonitor()
    
    /// Manages authentication state for the application.
    @StateObject private var authViewModel = AuthViewModel()
    
    /// Manages the onboarding tour for new users.
    @StateObject private var onboardingViewModel = onboardingModel()
    
    /// Configures Firebase during app initialization.
    init() {
        FirebaseApp.configure()
    }
    
    /// The main scene for the app, specifying the initial view and environment objects.
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(networkMonitor)
                .environmentObject(authViewModel)
                .environmentObject(onboardingViewModel)
        }
    }
}

/// The application delegate to manage app lifecycle and notification handling.
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    /// Called when the application has finished launching.
    ///
    /// - Parameters:
    ///   - application: The shared `UIApplication` instance.
    ///   - launchOptions: A dictionary of launch options.
    /// - Returns: A Boolean value indicating whether the app launched successfully.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Set the notification center delegate to handle notifications.
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    /// Handles notifications when the app is in the foreground.
    ///
    /// - Parameters:
    ///   - center: The `UNUserNotificationCenter` instance.
    ///   - notification: The notification being presented.
    ///   - completionHandler: A closure to specify how to present the notification.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Present notification as a banner with sound and badge.
        completionHandler([.banner, .sound, .badge])
    }
    
    /// Handles user interactions with notifications.
    ///
    /// - Parameters:
    ///   - center: The `UNUserNotificationCenter` instance.
    ///   - response: The user’s response to the notification.
    ///   - completionHandler: A closure to indicate the response has been handled.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Log the action identifier for debugging purposes.
        print("Received notification response: \(response.actionIdentifier)")
        completionHandler()
    }
}
