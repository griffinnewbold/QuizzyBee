//
//  searchBar.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A reusable search bar component for the dashboard.
///
/// - Purpose:
///   - Allows users to search for relevant decks.
///   - Provides a clear button to reset the search text.
///
/// - Features:
///   - A magnifying glass icon indicating search functionality.
///   - A text field for input with a customizable placeholder.
///   - A clear button (`xmark.circle.fill`) to reset the search field when not empty.
///   - Optional submit action triggered on pressing the return key.
///
/// - Parameters:
///   - searchText: A binding to the text entered in the search field.
///   - placeholder: A string to display as a placeholder in the search bar.
///   - onSubmit: An optional closure executed when the search is submitted.
struct searchBar: View {
    /// The search text entered by the user.
    @Binding var searchText: String
    
    /// Placeholder text displayed in the search bar.
    var placeholder: String
    
    /// Closure to execute when the user submits a search.
    var onSubmit: (() -> Void)? = nil

    /// The body of the search bar.
    var body: some View {
        HStack {
            // Magnifying glass icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Search text field
            TextField(placeholder, text: $searchText)
                .submitLabel(.search) // Sets the keyboard return key to "Search"
                .onSubmit { onSubmit?() } // Executes the submit action when the return key is pressed
                .foregroundColor(.primary)
            
            // Clear button to reset search text
            if !searchText.isEmpty {
                Button(action: {
                    searchText = "" // Clears the search text
                    onSubmit?() // Optionally triggers the submit action
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8) // Padding inside the search bar
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6)) // Light grey background for the search bar
        )
        .padding(.horizontal) // Adds horizontal padding for the entire search bar
    }
}
