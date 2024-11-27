import SwiftUI

struct QuizResponse: Codable {
    let questions: [GeneratedQuizQuestion]
}

struct GeneratedQuizQuestion: Codable {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

// MARK: - Quiz View
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
    
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            
            if isLoading {
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
                        Task {
                            await loadQuestions()
                        }
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
        .task {
            await loadQuestions()
        }
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
            generatedQuestions = try await service.generateQuiz(basedOn: questions)
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
