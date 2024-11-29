import SwiftUI

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
