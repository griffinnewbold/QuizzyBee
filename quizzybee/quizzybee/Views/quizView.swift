//
//  newCardView.swift
//  quizzybee
//
//  Created by Tommy Lam on 2024/11/10.
//

import SwiftUI

struct quizView: View {
    let deckTitle: String
    let apiKey: String
    @Binding var questions: [String]
    @Binding var answers: [String]
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showResults = false
    @State private var score = 0
    @State private var isLoading = true
    @State private var generatedQuestions: [GeneratedQuizQuestion] = []
    @State private var error: QuizError? = nil
    @State private var showQuestionCountSelector = true
    @State private var selectedQuestionCount = 5
    
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            
            if showQuestionCountSelector {
                questionCountSelector
            } else if isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Generating quiz questions...")
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = error {
                VStack(spacing: 20) {
                    Text("Error generating quiz")
                        .font(.headline)
                    Text(error.errorDescription ?? "Unknown error")
                        .font(.subheadline)
                        .padding()
                        .multilineTextAlignment(.center)
                    Button("Try Again") {
                        showQuestionCountSelector = true
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding()
            } else {
                quizContent
            }
        }
        .navigationTitle("\(deckTitle) Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var questionCountSelector: some View {
        VStack(spacing: 20) {
            Text("How many questions would you like?")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Picker("Number of Questions", selection: $selectedQuestionCount) {
                ForEach(1...20, id: \.self) { count in
                    Text("\(count)").tag(count)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Button("Start Quiz") {
                showQuestionCountSelector = false
                Task {
                    await loadQuestions()
                }
            }
            .font(.system(size: 16, weight: .medium))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding()
    }
    
    // MARK: - Quiz Content View
    private var quizContent: some View {
        VStack(spacing: 20) {
            if showResults {
                VStack(spacing: 20) {
                    Text("Quiz Results")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("\(score)/\(generatedQuestions.count)")
                        .font(.system(size: 40, weight: .bold))
                    
                    Button("New Quiz") {
                        showQuestionCountSelector = true
                        score = 0
                        currentQuestionIndex = 0
                        selectedAnswer = nil
                        showResults = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            } else {
                Text("\(currentQuestionIndex + 1)/\(generatedQuestions.count)")
                    .font(.system(size: 16, weight: .medium))
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(generatedQuestions[currentQuestionIndex].question)
                        .font(.system(size: 16, weight: .medium))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    ForEach(0..<generatedQuestions[currentQuestionIndex].options.count, id: \.self) { index in
                        Button(action: {
                            selectedAnswer = index
                            if index == generatedQuestions[currentQuestionIndex].correctAnswer {
                                score += 1
                            }
                        }) {
                            Text(generatedQuestions[currentQuestionIndex].options[index])
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
                    
                    if let selectedAnswer = selectedAnswer {
                        VStack(alignment: .leading, spacing: 10) {
                            if selectedAnswer == generatedQuestions[currentQuestionIndex].correctAnswer {
                                Text("Correct!")
                                    .foregroundColor(.green)
                                    .font(.headline)
                            } else {
                                Text("Incorrect")
                                    .foregroundColor(.red)
                                    .font(.headline)
                            }
                            
                            Text("Explanation: \(generatedQuestions[currentQuestionIndex].explanation)")
                                .font(.subheadline)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            Button("Next") {
                                if currentQuestionIndex < generatedQuestions.count - 1 {
                                    currentQuestionIndex += 1
                                    self.selectedAnswer = nil
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
                }
                .padding()
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func loadQuestions() async {
        isLoading = true
        error = nil
        currentQuestionIndex = 0
        selectedAnswer = nil
        showResults = false
        score = 0
        
        do {
            let service = OpenAIService(apiKey: apiKey)
            // Pass the selected question count to the quiz generation
            generatedQuestions = try await service.generateQuiz(basedOn: questions, questionCount: selectedQuestionCount)
            isLoading = false
        } catch let error as QuizError {
            self.error = error
            isLoading = false
        } catch {
            self.error = .processingError(error)
            isLoading = false
        }
    }
    
    private func backgroundColor(for index: Int) -> Color {
        guard let selectedAnswer = selectedAnswer else {
            return .white
        }
        
        if index == selectedAnswer {
            return index == generatedQuestions[currentQuestionIndex].correctAnswer ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
        }
        
        if index == generatedQuestions[currentQuestionIndex].correctAnswer {
            return Color.green.opacity(0.3)
        }
        
        return .white
    }
}
