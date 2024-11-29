import SwiftUI

struct deckCardSummaryRow: View {
    var deckCard: Set
    @AppStorage private var notificationsEnabled: Bool
    @State private var showShareSheet = false

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

            // Bell Button
            Button(action: {
                withAnimation {
                    notificationsEnabled.toggle()
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

            // Share Button
            Button(action: {
                showShareSheet.toggle()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.gray)
                    .offset(y: -2)
            }
            .buttonStyle(BorderlessButtonStyle())
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(deckCard: deckCard, isPresented: $showShareSheet)
                    .environmentObject(AuthViewModel())
            }
        }
    }
}

struct ShareSheet: View {
    var deckCard: Set
    @Binding var isPresented: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var userIDToShare = ""
    @State private var shareError: String? = nil
    @State private var isSharing = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.ignoresSafeArea() // Background color
                
                VStack {
                    // Header
                    VStack(spacing: 10) {
                        Text("Share Deck")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                            .padding(.top, 20)

                        Text("Enter the User ID (UID) to share this deck with.")
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }

                    // Input Field Section
                    VStack(spacing: 15) {
                        TextField("User ID (UID)", text: $userIDToShare)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal, 20)

                        if let shareError = shareError {
                            Text(shareError)
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.top, 20)

                    // Share Button
                    Button(action: {
                        shareDeck()
                    }) {
                        Text(isSharing ? "Sharing..." : "Share Deck")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 30)

                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Cancel")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
    }

    /// Shares the deck with the specified UID if the user exists.
    private func shareDeck() {
        guard !userIDToShare.isEmpty else {
            shareError = "Please enter a User ID."
            return
        }

        isSharing = true
        shareError = nil

        authViewModel.fetchUser(withID: userIDToShare) { user in
            guard user != nil else {
                shareError = "The User ID you entered does not exist."
                isSharing = false
                return
            }

            // User exists, share the deck
            let deckData = deckCard.toDictionary()
            let userRef = self.authViewModel.dbRef.child("users").child(userIDToShare).child("sets").child(deckCard.id)

            userRef.setValue(deckData) { error, _ in
                if let error = error {
                    print("Error sharing deck: \(error.localizedDescription)")
                    shareError = "Failed to share deck. Please try again."
                } else {
                    print("Deck shared successfully.")
                    isPresented = false
                }
                isSharing = false
            }
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
