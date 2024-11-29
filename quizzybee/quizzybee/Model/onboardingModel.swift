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
        case defaultDeck
        case deckDetails
        
        var message: String {
            switch self {
                case .welcome: return "Welcome to Quizzybee! Would you like a quick tour?"
                case .defaultDeck: return "This is your starter deck. Click to explore!"
                case .deckDetails: return "Here you can practice with flashcards and take quizzes"
            }
        }
    }
    
    // show tour
    func startTour(userID: String) {
        print("Starting tour for user")
        currentStep = 0
        showTour = true
        dbRef.child("users").child(userID).child("hasCompletedOnboarding").setValue(false)
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
