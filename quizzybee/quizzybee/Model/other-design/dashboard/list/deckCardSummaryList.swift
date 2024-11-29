//
//  deckCardSummaryList.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct deckCardSummaryList: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var tourGuide: onboardingModel
    @State private var defaultDeckFrame: CGRect = .zero
    @State private var selectedDeck: Set? = nil
    @State private var isActive = false
    
    let targetDecks: [Set]
    
    var body: some View {
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
                    
                    NavigationLink(
                        destination: existingDeckView(set: targetDecks[index]),
                        isActive: Binding(
                            get: { selectedDeck == targetDecks[index] && isActive },
                            set: { if !$0 { isActive = false; selectedDeck = nil } }
                        )
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .overlay {
            if tourGuide.currentStep == 1,
               defaultDeckFrame != .zero {
                tipsAnimation(
                    message: onboardingModel.TourStep.defaultDeck.message,
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
    }
}
