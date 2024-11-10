//
//  dashboardView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI

struct dashboardView: View {
    
    @State private var searchText = ""
    @State private var noResults = false
    @State var allDecks: [DeckCardSummary] = decks
    
    var filteredDecks: [DeckCardSummary] {
        if searchText.isEmpty {
            return allDecks
        } else {
            return allDecks.filter { deck in
                deck.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex:"7B7B7B").ignoresSafeArea()
            VStack {
                headerForDashboard()
                
                searchBar(searchText: $searchText,
                          placeholder: "search deck...",
                          onSubmit: {
                    if !searchText.isEmpty && filteredDecks.isEmpty {
                        noResults = true
                    }
                })
                
                deckCardSummaryList(targetDecks: filteredDecks)
            }
            .alert("No Results", isPresented: $noResults) {
                Button("OK", role: .cancel) {
                    noResults = false
                }
            } message: {
                Text("No decks found matching '\(searchText)'")
            }
        }
    }
}

#Preview {
    dashboardView()
}
