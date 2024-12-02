//
//  EditDeckTitleView.swift
//  quizzybee
//
//  Created by ChiaPeng Wu on 12/1/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

/// A view for editing the title of a flashcard deck.
struct EditDeckTitleView: View {
    /// The unique identifier of the deck.
    let deckID: String
    /// The current title of the deck, bound to the parent view for updates.
    @Binding var title: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Background color
            Color.yellow.edgesIgnoringSafeArea(.all)

            VStack {
                // Navigation bar with a back button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .padding(.leading)

                    Spacer()
                }
                .padding(.top)

                // Title label
                Text("Edit Deck Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Text field for editing the deck title
                TextField("Enter new deck title", text: $title)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal)

                // Save button
                Button(action: updateDeckTitle) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
        }
    }

    /// Updates the deck title in Firebase.
    func updateDeckTitle() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }

        let userID = user.uid
        let ref = Database.database().reference()
        let deckTitleRef = ref.child("users").child(userID).child("sets").child(deckID).child("title")

        // Save the updated title to Firebase
        deckTitleRef.setValue(title) { error, _ in
            if let error = error {
                print("Error updating deck title: \(error.localizedDescription)")
            } else {
                print("Deck title successfully updated.")
                // Dismiss the view after saving
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
