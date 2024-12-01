//
//  deckCardSummaryList.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// show list of decks
/// partner with tour guides and navigation
struct deckCardSummaryList: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var tourGuide: onboardingModel
    @State private var defaultDeckFrame: CGRect = .zero
    @State private var selectedDeck: Set? = nil
    @State private var isActive = false
    
    let targetDecks: [Set]
    
    var body: some View {
        ZStack {
            List {
                ForEach(targetDecks.indices, id: \.self) { index in
                    ZStack {
                        deckRow(
                            deckCard: targetDecks[index],
                            index: index,
                            showGeometry: index == 0,
                            defaultDeckFrame: $defaultDeckFrame,
                            onTap: {
                                if tourGuide.currentStep == 1,
                                   let userID = authViewModel.user?.userID {
                                    tourGuide.nextStep(userID: userID)
                                }
                                selectedDeck = targetDecks[index]
                                isActive = true
                            },
                            onDelete: {
                                authViewModel.deleteDeck(setId: targetDecks[index].id)
                            }
                        )
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            if tourGuide.currentStep == 1,
               defaultDeckFrame != .zero {
                tipsAnimation(
                    message: onboardingModel.TourStep.deck.message,
                    targetFrame: defaultDeckFrame,
                    onSkip: {
                        if let userID = authViewModel.user?.userID {
                            tourGuide.skipTour(userID: userID)
                        }
                    }
                )
                .zIndex(1)
            }
        }
        .navigationDestination(isPresented: $isActive) {
            if let deck = selectedDeck {
                existingDeckView(set: deck).environmentObject(authViewModel).environmentObject(tourGuide)
            }
        }
    }
}
