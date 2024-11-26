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
