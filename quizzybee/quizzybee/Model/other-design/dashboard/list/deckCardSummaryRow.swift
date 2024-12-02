import SwiftUI

/// A row design for displaying a single deck in the deck list.
///
/// Each row includes:
/// - A navigation link to view the deck details.
/// - A bell button to toggle notifications for the deck.
/// - A share button to share the deck with other users.
///
/// - Parameters:
///   - deckCard: The `Set` object representing the deck to display.
struct deckCardSummaryRow: View {
    /// The deck to display in this row.
    var deckCard: Set
    
    /// Indicates whether notifications are enabled for this deck.
    @AppStorage private var notificationsEnabled: Bool
    
    /// State to show or hide the share sheet.
    @State private var showShareSheet = false

    /// Initializes the row with a given deck.
    /// - Parameter deckCard: The deck to display in this row.
    init(deckCard: Set) {
        self.deckCard = deckCard
        let storageKey = "notifications-enabled-\(deckCard.id)"
        _notificationsEnabled = AppStorage(wrappedValue: false, storageKey)
    }

    /// The view's body, containing the row layout.
    var body: some View {
        HStack {
            // Navigation link to the deck details
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

            // Bell Button for toggling notifications
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

            // Share Button for sharing the deck
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

/// A view for sharing a deck with another user by entering their User ID (UID).
struct ShareSheet: View {
    /// The deck to be shared.
    var deckCard: Set
    
    /// Indicates whether the sheet is presented.
    @Binding var isPresented: Bool
    
    /// The authentication view model for user operations.
    @EnvironmentObject var authViewModel: AuthViewModel
    
    /// The User ID of the recipient to share the deck with.
    @State private var userIDToShare = ""
    
    /// An optional error message displayed if sharing fails.
    @State private var shareError: String? = nil
    
    /// Indicates whether the deck is currently being shared.
    @State private var isSharing = false

    /// The view's body, containing the UI for sharing the deck.
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

// MARK: - Preview
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

