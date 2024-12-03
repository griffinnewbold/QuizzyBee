//
//  deckCardSummaryList.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A view displaying a list of decks, with support for onboarding guidance and navigation.
///
/// This view works in conjunction with the `onboardingModel` to guide users through the application
/// and provides navigation to detailed views for each deck.
///
/// - Requires:
///   - `AuthViewModel`: An environment object managing user authentication and deck operations.
///   - `onboardingModel`: An environment object managing onboarding steps and animations.
///
/// - Note:
///   - The first deck in the list displays onboarding tips if the user is in the relevant step.
///   - Decks can be deleted using the swipe-to-delete functionality.
///
/// - Parameters:
///   - targetDecks: An array of `Set` objects representing the decks to be displayed.
struct deckCardSummaryList: View {
    /// The authentication view model, managing user authentication and deck-related operations.
    @EnvironmentObject var authViewModel: AuthViewModel

    /// The onboarding model, managing onboarding steps and tips display.
    @EnvironmentObject var tourGuide: onboardingModel

    /// The frame of the first deck row, used for positioning onboarding tips.
    @State private var defaultDeckFrame: CGRect = .zero

    /// The currently selected deck for navigation.
    @State private var selectedDeck: Set? = nil

    /// A flag indicating whether navigation to a detailed deck view is active.
    @State private var isActive = false

    /// The list of decks to be displayed in the view.
    let targetDecks: [Set]

    /// The body of the view, containing the list of decks and onboarding elements.
    var body: some View {
        ZStack {
            List {
                ForEach(targetDecks.indices, id: \.self) { index in
                    ZStack {
                        // Display a row for the current deck
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
                        .environmentObject(authViewModel)

                        // Navigation link to the detailed deck view
                        NavigationLink(
                            destination: existingDeckView(set: targetDecks[index])
                                .environmentObject(authViewModel)
                                .environmentObject(tourGuide),
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

            // Onboarding tips overlay
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
    }
}
