//
//  quizView.swift
//  quizzybee
//
//  Created by Tommy on 2024/11/8.
//

import SwiftUI

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

struct quizView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showResults = false
    @State private var score = 0
    @State private var shouldNavigateBack = false
    
    let questions = [
        // sample questions
        // will implement be later...
        QuizQuestion(
            question: "What is the correct way to declare a variable of type integer in Java?",
            options: [
                "var x = 10;",
                "Integer x = 10;",
                "int x = 10;",
                "Int x = 10;"
            ],
            correctAnswer: 2
        ),
        QuizQuestion(
            question: "Which access modifier makes a variable accessible only within its own class?",
            options: [
                "public",
                "protected",
                "default",
                "private"
            ],
            correctAnswer: 3
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                
                if showResults {
                    ResultsView(
                        score: score,
                        totalQuestions: questions.count,
                        onNewQuiz: {  // Make sure this closure is included
                            // Reset quiz
                            currentQuestionIndex = 0
                            selectedAnswer = nil
                            showResults = false
                            score = 0
                        },
                        shouldNavigateBack: $shouldNavigateBack
                    )
                } else {
                    VStack(spacing: 20) {
                        // Progress indicator
                        HStack {
                            Button(action: {
                                if currentQuestionIndex > 0 {
                                    currentQuestionIndex -= 1
                                    selectedAnswer = nil
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .imageScale(.large)
                            }
                            
                            Spacer()
                            
                            Text("\(currentQuestionIndex + 1)/\(questions.count)")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.horizontal)
                        .padding(.top, 60) // Add top padding to account for status bar
                        
                        // Rest of the view remains the same
                        // Question card
                        VStack(alignment: .leading, spacing: 16) {
                            Text(questions[currentQuestionIndex].question)
                                .font(.system(size: 16, weight: .medium))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            // Answer options
                            ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                                Button(action: {
                                    selectedAnswer = index
                                }) {
                                    Text(questions[currentQuestionIndex].options[index])
                                        .font(.system(size: 16))
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(backgroundColor(for: index))
                                        )
                                        .foregroundColor(.black)
                                }
                            }
                            
                            if selectedAnswer != nil {
                                Button("Next") {
                                    if questions[currentQuestionIndex].correctAnswer == selectedAnswer {
                                        score += 1
                                    }
                                    
                                    if currentQuestionIndex < questions.count - 1 {
                                        currentQuestionIndex += 1
                                        selectedAnswer = nil
                                    } else {
                                        showResults = true
                                    }
                                }
                                .font(.system(size: 16, weight: .medium))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        
                        Spacer() // Add spacer to push content to the top
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onChange(of: shouldNavigateBack) { oldValue, newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func backgroundColor(for index: Int) -> Color {
        guard let selectedAnswer = selectedAnswer else {
            return .white
        }
        
        if index == selectedAnswer {
            return index == questions[currentQuestionIndex].correctAnswer ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
        }
        
        if index == questions[currentQuestionIndex].correctAnswer {
            return Color.green.opacity(0.3)
        }
        
        return .white
    }
}

struct ResultsView: View {
    let score: Int
    let totalQuestions: Int
    let onNewQuiz: () -> Void
    @Binding var shouldNavigateBack: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quiz Results")
                .font(.system(size: 20, weight: .bold))
            
            Text("\(score)/\(totalQuestions)")
                .font(.system(size: 40, weight: .bold))
            
            VStack(spacing: 10) {
                Button("New Quiz") {
                    onNewQuiz()
                }
                .font(.system(size: 16, weight: .medium))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                
                Button("Return to Deck") {
                    shouldNavigateBack = true
                }
                .font(.system(size: 16, weight: .medium))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    quizView()
}
