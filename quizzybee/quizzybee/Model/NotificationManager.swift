//
//  NotificationManager.swift
//  quizzybee
//

import UserNotifications

class NotificationManager {
    static func scheduleWeeklyNotification(for deck: Set) {
        print("Attempting to schedule notification for deck: \(deck.title)")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Notification permission granted: \(granted)")
            if let error = error {
                print("Permission error: \(error)")
            }
            
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Time to Study!"
                content.body = "Don't forget to review your '\(deck.title)' deck"
                content.sound = .default
                
                // Test notification in 5 seconds
                print("Setting up 5-second test notification")
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(
                    identifier: "weekly-reminder-\(deck.id)",
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Successfully scheduled notification")
                        // Immediately check pending notifications after scheduling
                        checkPendingNotifications()
                    }
                }
            }
        }
    }
    
    static func removeNotification(for deck: Set) {
        print("Removing notification for deck: \(deck.title)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["weekly-reminder-\(deck.id)"]
        )
    }
    
    static func checkPendingNotifications() {
        print("Checking pending notifications...")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Number of pending notifications: \(requests.count)")
            for request in requests {
                print("ID: \(request.identifier)")
                print("Content: \(request.content.title) - \(request.content.body)")
                if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    print("Seconds remaining: \(trigger.timeInterval)")
                }
            }
        }
    }
}
