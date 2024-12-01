//
//  dashboardView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI
import Firebase

/// dashboard
struct dashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var tourGuide: onboardingModel
    @State private var searchText = ""
    @State private var noResults = false
    @State private var allDecks: [Set] = []
    @State private var showNetworkAlert: Bool = false
    
    private func loadDecks() {
        self.allDecks = []
        authViewModel.fetchUserSets { sets in
            DispatchQueue.main.async {
                self.allDecks = sets
            }
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
                    
                    // Search bar with refresh button
                    HStack {
                        searchBar(searchText: $searchText,
                                  placeholder: "search deck...",
                                  onSubmit: {
                            if !searchText.isEmpty && filteredDecks.isEmpty {
                                noResults = true
                            }
                        })
                        
                        // Refresh button
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
                    
                    deckCardSummaryList(targetDecks: filteredDecks)
                        .environmentObject(authViewModel)
                        .environmentObject(tourGuide)
                    
                    addNewDeck()
                        .padding(.bottom, 30)
                }
                .alert("No Results", isPresented: $noResults) {
                    Button("OK", role: .cancel) { noResults = false }
                } message: {
                    Text("No decks found matching '\(searchText)'")
                }
                
                // Welcome and tour guide logic
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
