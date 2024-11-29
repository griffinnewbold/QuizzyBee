//
//  dashboardView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI

struct dashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var tourGuide: onboardingModel
    @State private var searchText = ""
    @State private var noResults = false
    @State private var allDecks: [Set] = []
    @State private var showNetworkAlert: Bool = false
    
    
    private func loadDecks() {
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
                    
                    searchBar(searchText: $searchText,
                              placeholder: "search deck...",
                              onSubmit: {
                        if !searchText.isEmpty && filteredDecks.isEmpty {
                            noResults = true
                        }
                    })
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
                
                // show welcome
                if !(authViewModel.user?.hasCompletedOnboarding ?? false) || tourGuide.showTour {
                    if tourGuide.currentStep == 0 {
                        welcomeAndEnding(mode: "welcome", button: "Let's Explore.")
                    }
                }
                
                // show other tips
                if let currentStep = onboardingModel.TourStep.allCases[safe: tourGuide.currentStep],
                   (8...11).contains(tourGuide.currentStep), let userID = authViewModel.user?.userID {
                    tipView(
                        currentStep: currentStep,
                        nextStep: { tourGuide.nextStep(userID: userID) },
                        skipTour: { tourGuide.skipTour(userID: userID) }
                    )
                }
                
                // show ending
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
            loadDecks()
            
            // for instant change
            NotificationCenter.default.addObserver(forName: NSNotification.Name("RefreshDashboard"),
                                                   object: nil,
                                                   queue: .main) { _ in
                loadDecks()
            }
            if networkMonitor.isConnected {
                loadDecks()
            } else if !showNetworkAlert {
                showNetworkAlert = true
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

#Preview {
    dashboardView()
        .environmentObject(AuthViewModel())
        .environmentObject(NetworkMonitor())
        .environmentObject(onboardingModel())
}
