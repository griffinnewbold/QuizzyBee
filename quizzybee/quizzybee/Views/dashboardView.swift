//
//  dashboardView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI

struct dashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    @State private var noResults = false
    @State private var allDecks: [Set] = []
    
    var filteredDecks: [Set] {
        if searchText.isEmpty {
            return allDecks
        } else {
            return allDecks.filter { deck in
                deck.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                dashboardBackgroundView()
                
                VStack(spacing: 0) {
                    headerForDashboard()
                        .padding(.bottom, 50)
                    
                    searchBar(searchText: $searchText,
                              placeholder: "search deck...",
                              onSubmit: {
                        if !searchText.isEmpty && filteredDecks.isEmpty {
                            noResults = true
                        }
                    })
                    .padding(.bottom, 50)
                    
                    Text("Welcome, \(user.fullName)")
                        .font(.title)
                        .padding()
                    
                    deckCardSummaryList(targetDecks: filteredDecks)
                    
                    addNewCard()
                        .padding(.bottom, 30)
                }
                .alert("No Results", isPresented: $noResults) {
                    Button("OK", role: .cancel) { noResults = false }
                } message: {
                    Text("No decks found matching '\(searchText)'")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    dashboardView(user: User(userID: "sampleID", fullName: "Sample User", email: "sample@example.com"))
}
