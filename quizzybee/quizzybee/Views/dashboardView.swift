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
    
    private func loadDecks() {
        authViewModel.fetchUserSets { sets in
            
            self.allDecks = sets
        }
    }
    
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
                        .padding(.bottom, 120)
                    
                    searchBar(searchText: $searchText,
                              placeholder: "search deck...",
                              onSubmit: {
                        if !searchText.isEmpty && filteredDecks.isEmpty {
                            noResults = true
                        }
                    })
                    .padding(.bottom, 50)
                    
                    deckCardSummaryList(targetDecks: filteredDecks)
                    
                    addNewDeck()
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
        .onAppear {
            loadDecks()
        }
        .onChange(of: authViewModel.user?.sets) {
            loadDecks()
        }
    }
}

#Preview {
    dashboardView()
        .environmentObject(AuthViewModel())
}
