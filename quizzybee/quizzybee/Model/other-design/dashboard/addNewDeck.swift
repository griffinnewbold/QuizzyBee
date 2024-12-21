//
//  addNewDeck.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A button component that navigates users to add a new deck.
///
/// - Features:
///   - Displays a button with a "plus" icon and label.
///   - When tapped, opens a sheet presenting the `newCardView` to add a new deck.
struct addNewDeck: View {
    /// A state variable to control the presentation of the `newCardView`.
    @State private var addNewDeck = false

    /// The body of the button view.
    var body: some View {
        Button {
            addNewDeck = true
        } label: {
            VStack {
                HStack {
                    // "Plus" icon
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    // Button label
                    Text("Add A New Deck")
                        .font(.system(size: 14))
                        .bold()
                        .foregroundStyle(.black)
                }
            }
            .padding() // Adds padding inside the button
            .frame(width: 370) // Sets a fixed width for the button
            .background(Color.white.opacity(0.8)) // Semi-transparent white background
            .cornerRadius(10) // Rounds the corners of the button
            .shadow(radius: 2) // Adds a shadow around the button
        }
        // Presents the `newCardView` when the button is tapped
        .sheet(isPresented: $addNewDeck) {
            newCardView()
        }
    }
}
