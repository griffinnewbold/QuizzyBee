//
//  onboardingModel.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import FirebaseDatabase
import UIKit

/// Model to manage the user onboarding tour.
///
/// - Purpose:
///   - Guides users through an interactive onboarding experience.
///   - Tracks the current step and highlights relevant UI elements.
///   - Stores the onboarding progress in Firebase Realtime Database.
class onboardingModel: ObservableObject {
    /// The current step in the onboarding tour.
    @Published var currentStep = 0
    
    /// A flag indicating whether the tour is currently being shown.
    @Published var showTour = false
    
    /// Reference to the Firebase Realtime Database.
    private let dbRef = Database.database().reference()
    
    /// Enumeration of all onboarding tour steps with associated messages and UI highlight areas.
    enum TourStep: CaseIterable {
        case welcome
        case deck
        case deckDetailTitle
        case deckDetailSearch
        case deckDetailCard
        case addCard
        case reviewAndQuiz
        case back
        case searchDeck
        case addDeck
        case profile
        case setting
        case ending
        
        /// A descriptive message for each step in the tour.
        var message: String {
            switch self {
            case .welcome: return "Welcome to Quizzybee! Would you like a quick tour?"
            case .deck: return "Click to explore!"
            case .deckDetailTitle: return "Change your deck title here."
            case .deckDetailSearch: return "Type to search your cards."
            case .deckDetailCard: return "Click to flip the card and see the answer. Play with the sound."
            case .addCard: return "Manual or use AI to add a new card."
            case .reviewAndQuiz: return "Create AI Generated Quizzes."
            case .back: return "Go back to the dashboard."
            case .searchDeck: return "Search your deck here."
            case .addDeck: return "Click to add a new deck!"
            case .profile: return "Change your profile here."
            case .setting: return "See this tour again or log out."
            case .ending: return "Congratulations! You've finished the tour. Enjoy using Quizzybee!"
            }
        }
        
        /// The frame of the UI element to highlight for the current step.
        var highlightFrame: CGRect {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            switch self {
            case .welcome, .deck, .ending:
                return CGRect(x: 50, y: 100, width: 200, height: 100)
            case .deckDetailTitle:
                return CGRect(x: 20, y: 80, width: screenWidth - 40, height: 44)
            case .deckDetailSearch:
                return CGRect(x: 20, y: 160, width: screenWidth - 40, height: 50)
            case .deckDetailCard:
                return CGRect(x: 20, y: 220, width: screenWidth - 40, height: screenWidth - 40)
            case .addCard:
                return CGRect(x: 20, y: screenHeight - 240, width: screenWidth - 40, height: 120)
            case .reviewAndQuiz:
                return CGRect(x: 20, y: screenHeight - 100, width: screenWidth - 40, height: 50)
            case .back:
                return CGRect(x: 10, y: 80, width: 44, height: 44)
            case .addDeck:
                return CGRect(x: 20, y: screenHeight - 120, width: screenWidth - 40, height: 50)
            case .profile:
                return CGRect(x: 20, y: 60, width: 44, height: 44)
            case .setting:
                return CGRect(x: screenWidth - 60, y: 60, width: 44, height: 44)
            case .searchDeck:
                return CGRect(x: 20, y: 220, width: screenWidth - 40, height: 50)
            }
        }
    }
    
    // MARK: - Tour Management
    
    /// Starts the onboarding tour.
    /// - Parameter userID: The user's unique ID.
    func startTour(userID: String) {
        currentStep = 0
        showTour = true
        dbRef.child("users").child(userID).child("hasCompletedOnboarding").setValue(false)
    }
    
    /// Skips the onboarding tour.
    /// - Parameter userID: The user's unique ID.
    func skipTour(userID: String) {
        currentStep = -1
        showTour = false
        dbRef.child("users").child(userID).child("hasCompletedOnboarding").setValue(true)
    }
    
    /// Moves to the next step in the onboarding tour.
    /// - Parameter userID: The user's unique ID.
    func nextStep(userID: String) {
        if currentStep < TourStep.allCases.count - 1 {
            currentStep += 1
        } else {
            dbRef.child("users").child(userID).child("hasCompletedOnboarding").setValue(true)
            currentStep = -1
            showTour = false
        }
    }
}
