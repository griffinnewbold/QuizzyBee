//
//  EditDeckTitleView.swift
//  quizzybee
//
//  Created by ChiaPeng Wu on 11/29/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct EditDeckTitleView: View {
    let deckID: String
    @Binding var title: String // Binding to update the title in the parent view
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)

            VStack {
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

                Text("Edit Deck Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                TextField("Enter new deck title", text: $title)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal)

                Button(action: updateDeckTitle) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
        }
    }

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
                presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
            }
        }
    }
}
