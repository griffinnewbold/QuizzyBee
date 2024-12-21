//
//  dashboardView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI
import Firebase

/// The main dashboard view for the Quizzybee app.
///
/// - Purpose:
///   - Displays the user's decks.
///   - Provides functionality to search, refresh, and add new decks.
///   - Integrates onboarding and tour guidance.
struct dashboardView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var authViewModel: AuthViewModel         // Manages user authentication and data.
    @EnvironmentObject var networkMonitor: NetworkMonitor       // Tracks network connectivity.
    @EnvironmentObject var tourGuide: onboardingModel           // Handles onboarding and tour steps.
    @EnvironmentObject var envLoader: EnvironmentLoader         // Manages environment variables

    // MARK: - State Properties
    @State private var searchText = ""                          // The search query entered by the user.
    @State private var noResults = false                        // Flag to show "no results" alert.
    @State private var allDecks: [Set] = []                     // The list of all decks for the user.
    @State private var showNetworkAlert: Bool = false           // Flag to show network error alert.

    // MARK: - Helper Methods

    /// Loads the user's decks from Firebase.
    private func loadDecks() {
        self.allDecks = []
        authViewModel.fetchUserSets { sets in
            DispatchQueue.main.async {
                self.allDecks = sets
            }
        }
    }

    /// Filters decks based on the search query.
    var filteredDecks: [Set] {
        if searchText.isEmpty {
            return allDecks
        } else {
            return allDecks.filter { deck in
                deck.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                dashboardBackgroundView()
                
                VStack(spacing: 0) {
                    // Header
                    headerForDashboard()
                        .padding(.bottom, 120)
                    
                    // Search bar with refresh button
                    HStack {
                        searchBar(
                            searchText: $searchText,
                            placeholder: "search deck...",
                            onSubmit: {
                                if !searchText.isEmpty && filteredDecks.isEmpty {
                                    noResults = true
                                }
                            }
                        )
                        
                        // Refresh Button
                        Button(action: {
                            if networkMonitor.isConnected {
                                loadDecks()
                            } else {
                                showNetworkAlert = true
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.yellow)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.bottom, 50)
                    
                    // Deck list
                    deckCardSummaryList(targetDecks: filteredDecks)
                        .environmentObject(authViewModel)
                        .environmentObject(tourGuide)
                        .environmentObject(envLoader)
                    
                    // Add new deck button
                    addNewDeck()
                        .padding(.bottom, 30)
                }
                .alert("No Results", isPresented: $noResults) {
                    Button("OK", role: .cancel) { noResults = false }
                } message: {
                    Text("No decks found matching '\(searchText)'")
                }
                
                // Onboarding and tour guidance
                if !(authViewModel.user?.hasCompletedOnboarding ?? false) || tourGuide.showTour {
                    if tourGuide.currentStep == 0 {
                        welcomeAndEnding(mode: "welcome", button: "Let's Explore.")
                    }
                }
                
                if let currentStep = onboardingModel.TourStep.allCases[safe: tourGuide.currentStep],
                   (8...11).contains(tourGuide.currentStep), let userID = authViewModel.user?.userID {
                    tipView(
                        currentStep: currentStep,
                        nextStep: { tourGuide.nextStep(userID: userID) },
                        skipTour: { tourGuide.skipTour(userID: userID) }
                    )
                }
                
                if tourGuide.currentStep == 12 {
                    welcomeAndEnding(mode: "ending", button: "OK")
                }
            }
            .alert("Network Error", isPresented: $showNetworkAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("There is a network issue. Please try again later.")
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if networkMonitor.isConnected {
                loadDecks()
            } else if !showNetworkAlert {
                showNetworkAlert = true
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("RefreshDashboard"),
                                                   object: nil,
                                                   queue: .main) { _ in
                if networkMonitor.isConnected {
                    loadDecks()
                } else if !showNetworkAlert {
                    showNetworkAlert = true
                }
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshDashboard"), object: nil)
        }
        .onChange(of: authViewModel.user?.sets) {
            if networkMonitor.isConnected {
                loadDecks()
            } else {
                showNetworkAlert = true
            }
        }
    }
}
