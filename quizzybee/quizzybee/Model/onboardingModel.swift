//
//  onboardingModel.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import FirebaseDatabase

class onboardingModel: ObservableObject {
    @Published var currentStep = 0
    @Published var showTour = false
    private let dbRef = Database.database().reference()
    
    enum TourStep: CaseIterable {
        case welcome // welcome to quizbee
        case deck
        case deckDetailTitle
        case deckDetailSearch
        case deckDetailCard
        case addCard
        case reviewAndQuiz
        case searchDeck
        case addDeck
        case profile
        case setting
        
        var message: String {
            switch self {
            case .welcome: return "Welcome to Quizzybee! Would you like a quick tour?"
            case .deck: return "Click to explore!"
            case .deckDetailTitle: return "Change your deck title here."
            case .deckDetailSearch: return "Type to search your cards."
            case .deckDetailCard: return "Click to flip the card and see the answer. Play with the sound."
            case .addCard: return "Manual or use AI to add a new card."
            case .reviewAndQuiz: return "Review your cards or see AI generated quizzes."
            case .searchDeck: return "Search your deck here."
            case .addDeck: return "Click to add a new deck!"
            case .profile: return "Change your profile here."
            case .setting: return "See this tour again or log out."
            }
        }
    }
    
    // show tour
    func startTour(userID: String) {
        print("Starting tour for user")
        currentStep = 0
        showTour = true
    }
    
    // if user clicks 'x', then skip the tour
    func skipTour(userID: String) {
        print("Skipping tour for user")
        // no tour/welcome message shown
        currentStep = -1
        showTour = false
        dbRef.child("users").child(userID).child("hasCompletedOnboarding").setValue(true)
    }
    
    func nextStep(userID: String) {
        if currentStep < TourStep.allCases.count - 1 {
            currentStep += 1
        } else {
            print("Tour completed.")
            dbRef.child("users").child(userID).child("hasCompletedOnboarding").setValue(true)
            showTour = false
        }
        print("Next step on click, the current step is \(currentStep)")
    }
}
