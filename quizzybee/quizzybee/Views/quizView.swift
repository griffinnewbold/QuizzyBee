//
//  newCardView.swift
//  quizzybee
//
//  Created by Tommy Lam on 2024/11/10.
//

import SwiftUI

/// A view for conducting a quiz based on a given deck of flashcards.
struct quizView: View {
    // MARK: - Properties

    /// The title of the deck for the quiz.
    let deckTitle: String
    /// The OpenAI API key for generating quiz questions.
    let apiKey: String
    /// A binding to the array of questions for the quiz.
    @Binding var questions: [String]
    /// A binding to the array of answers for the quiz.
    @Binding var answers: [String]

    // MARK: - State Variables

    @State private var currentQuestionIndex = 0            // Index of the current question in the quiz.
    @State private var selectedAnswer: Int? = nil          // Index of the selected answer.
    @State private var showResults = false                 // Whether to show the quiz results.
    @State private var score = 0                           // The user's current score in the quiz.
    @State private var isLoading = true                    // Whether the quiz is currently loading.
    @State private var generatedQuestions: [GeneratedQuizQuestion] = [] // Generated quiz questions.
    @State private var error: QuizError? = nil             // Error encountered during quiz generation.
    @State private var showQuestionCountSelector = true    // Whether to show the question count selector.
    @State private var selectedQuestionCount = 5           // Number of questions to generate.

    @Environment(\.presentationMode) var presentationMode // For dismissing the view.

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)

            VStack {
                // Back Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding()

                if showQuestionCountSelector {
                    questionCountSelector
                } else if isLoading {
                    loadingView
                } else if let error = error {
                    errorView(error: error)
                } else {
                    quizContent
                }
            }
            .navigationTitle("\(deckTitle) Quiz")
            .navigationBarHidden(true)
        }
    }

    // MARK: - Question Count Selector

    private var questionCountSelector: some View {
        VStack(spacing: 20) {
            Text("How many questions would you like?")
                .font(.headline)
                .multilineTextAlignment(.center)

            Picker("Number of Questions", selection: $selectedQuestionCount) {
                ForEach(1...questions.count, id: \.self) { count in
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
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding()
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Generating quiz questions...")
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Error View

    private func errorView(error: QuizError) -> some View {
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
    }

    // MARK: - Quiz Content

    private var quizContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                if showResults {
                    resultsView
                } else {
                    questionView
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }

    private var resultsView: some View {
        VStack(spacing: 20) {
            Text("Quiz Results")
                .font(.system(size: 20, weight: .bold))

            Text("\(score)/\(generatedQuestions.count)")
                .font(.system(size: 40, weight: .bold))

            Button("New Quiz") {
                restartQuiz()
            }
            .font(.system(size: 16, weight: .medium))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }

    private var questionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(generatedQuestions[currentQuestionIndex].question)
                .font(.system(size: 16, weight: .medium))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)

            ForEach(0..<generatedQuestions[currentQuestionIndex].options.count, id: \.self) { index in
                Button(action: {
                    handleAnswerSelection(for: index)
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
                answerFeedbackView(selectedAnswer: selectedAnswer)
            }
        }
        .padding()
    }

    private func answerFeedbackView(selectedAnswer: Int) -> some View {
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
                handleNextQuestion()
            }
            .font(.system(size: 16, weight: .medium))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
        }
    }

    // MARK: - Helper Methods

    private func loadQuestions() async {
        isLoading = true
        error = nil
        currentQuestionIndex = 0
        selectedAnswer = nil
        showResults = false
        score = 0

        do {
            let service = OpenAIService(apiKey: apiKey)
            generatedQuestions = try await service.generateQuiz(basedOn: questions, questionCount: selectedQuestionCount)
            isLoading = false
        } catch let quizError as QuizError {
            self.error = quizError
            isLoading = false
        } catch {
            self.error = .processingError(error)
            isLoading = false
        }
    }

    private func handleAnswerSelection(for index: Int) {
        selectedAnswer = index
        if index == generatedQuestions[currentQuestionIndex].correctAnswer {
            score += 1
        }
    }

    private func handleNextQuestion() {
        if currentQuestionIndex < generatedQuestions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
        } else {
            showResults = true
        }
    }

    private func restartQuiz() {
        showQuestionCountSelector = true
        score = 0
        currentQuestionIndex = 0
        selectedAnswer = nil
        showResults = false
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
