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
    
    enum TourStep {
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
    func startTour() {
        currentStep = 0
        showTour = true
    }
    
    // if user clicks 'x', then skip the tour
    func skipTour(userID: String) {
        showTour = false
        dbRef.child("users").child(userID).child("hasCompletedOnboarding").setValue(true)
    }
    
    func nextStep() {
        currentStep += 1
    }
}
