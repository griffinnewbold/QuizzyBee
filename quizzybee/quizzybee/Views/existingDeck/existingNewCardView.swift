//
//  existingNewCardView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/12.
//

import SwiftUI

struct existingNewCardView: View {
    @Binding var questions: [String]
    @Binding var answers: [String]
    @State private var newQuestion = ""
    @State private var newAnswer = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldNavigateToRateNewCard = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Add New Flashcard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 20) {
                    TextField("Type or hand write your question...", text: $newQuestion)
                        .padding()
                        .frame(width: 300, height: 280)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Type or hand write your answer...", text: $newAnswer)
                        .padding()
                        .frame(width: 300, height: 280)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    if !newQuestion.isEmpty && !newAnswer.isEmpty {
                        questions.append(newQuestion)
                        answers.append(newAnswer)
                        shouldNavigateToRateNewCard = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Save to Deck")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 60)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.yellow.edgesIgnoringSafeArea(.all))
//            .navigationDestination(isPresented: $shouldNavigateToRateNewCard) {
//                RateNewCardView(question: newQuestion, answer: newAnswer)
//                    .navigationBarBackButtonHidden(true)
//            }
        }
    }
}

//#Preview {
//    existingNewCardView()
//}
