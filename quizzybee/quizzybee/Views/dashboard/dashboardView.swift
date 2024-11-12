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
        NavigationStack {
            ZStack {
                dashboardBackgroundView()
                
                VStack(spacing: 0) {
                    headerForDashboard().padding(.bottom, 50)
                    
                    searchBar(searchText: $searchText,
                              placeholder: "search deck...",
                              onSubmit: {
                        if !searchText.isEmpty && filteredDecks.isEmpty {
                            noResults = true
                        }
                    }).padding(.bottom, 50)
                    
                    deckCardSummaryList(targetDecks: filteredDecks)
                    
                    addNewCard().padding(.bottom, 30)
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
}

#Preview {
    dashboardView()
}
