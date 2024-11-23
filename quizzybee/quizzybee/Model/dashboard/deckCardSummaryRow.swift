import SwiftUI
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

struct deckCardSummaryRow: View {
    var deckCard: Set
    @AppStorage private var notificationsEnabled: Bool
    
    init(deckCard: Set) {
        self.deckCard = deckCard
        let storageKey = "notifications-enabled-\(deckCard.id)"
        _notificationsEnabled = AppStorage(wrappedValue: false, storageKey)
    }
    
    var body: some View {
        HStack {
            NavigationLink(destination: existingDeckView(set: deckCard)) {
                VStack(alignment: .leading) {
                    Text(deckCard.title)
                        .font(.system(size: 14))
                        .bold()
                    
                    HStack {
                        Text("cards: ")
                            .font(.system(size: 10))
                        
                        Text("\(deckCard.words.count)")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            

            Button(action: {
                print("Bell button tapped for deck: \(deckCard.title)")
                withAnimation {
                    notificationsEnabled.toggle()
                    print("Notifications now \(notificationsEnabled ? "enabled" : "disabled")")
                    
                    if notificationsEnabled {
                        NotificationManager.scheduleWeeklyNotification(for: deckCard)
                    } else {
                        NotificationManager.removeNotification(for: deckCard)
                    }
                }
            }) {
                Image(systemName: notificationsEnabled ? "bell.fill" : "bell")
                    .foregroundColor(notificationsEnabled ? .blue : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.trailing, 10)
        }
    }
}
#Preview {
    Group {
        deckCardSummaryRow(deckCard: Set(
            id: "1",
            title: "Intro to Java",
            words: [
                Word(term: "Class", definition: "A blueprint for creating objects", color: "#FFFFFF"),
                Word(term: "Object", definition: "An instance of a class", color: "#FFFFFF")
            ]
        ))
        deckCardSummaryRow(deckCard: Set(
            id: "2",
            title: "Data Structures",
            words: [
                Word(term: "Array", definition: "A collection of elements", color: "#FFFFFF"),
                Word(term: "LinkedList", definition: "A sequence of elements", color: "#FFFFFF"),
                Word(term: "Stack", definition: "LIFO data structure", color: "#FFFFFF")
            ]
        ))
    }
}
