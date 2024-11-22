// QuizView.swift
import SwiftUI

// MARK: - Models
struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

struct QuizResponse: Codable {
    let questions: [GeneratedQuizQuestion]
}

struct GeneratedQuizQuestion: Codable {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

enum QuizError: Error, LocalizedError {
    case invalidResponse
    case generationFailed
    case noContent
    case invalidJSON
    case apiError(String)
    case processingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Failed to get a valid response from OpenAI"
        case .generationFailed:
            return "Failed to generate quiz questions"
        case .noContent:
            return "No content received from OpenAI"
        case .invalidJSON:
            return "Failed to parse response as JSON"
        case .apiError(let message):
            return "API Error: \(message)"
        case .processingError(let error):
            return "Error processing response: \(error.localizedDescription)"
        }
    }
}

// MARK: - OpenAI Service
struct OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generateQuiz(basedOn questions: [String]) async throws -> [GeneratedQuizQuestion] {
        print("Starting quiz generation with \(questions.count) base questions")
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are a helpful quiz generator. Always respond with valid JSON."],
            ["role": "user", "content": """
                Generate 10 multiple choice questions around related to these topics: \(questions.joined(separator: ", "))
                
                Respond with a JSON object in this exact format:
                {
                    "questions": [
                        {
                            "question": "question text",
                            "options": ["option1", "option2", "option3", "option4"],
                            "correctAnswer": 0,
                            "explanation": "explanation text"
                        }
                    ]
                }
                """]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "temperature": 0.7,
            "response_format": ["type": "json_object"]
        ]
        
        do {
            var request = URLRequest(url: URL(string: baseURL)!)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            
            print("Sending request to OpenAI...")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                
                // Print raw response for debugging
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw response: \(rawResponse)")
                }
                
                // Check for non-200 status code
                guard httpResponse.statusCode == 200 else {
                    throw QuizError.apiError("OpenAI returned status code \(httpResponse.statusCode)")
                }
            }
            
            let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            
            guard let content = openAIResponse.choices.first?.message.content else {
                throw QuizError.noContent
            }
            
            print("Received response content: \(content)")
            
            guard let jsonData = content.data(using: .utf8) else {
                throw QuizError.invalidJSON
            }
            
            let quizResponse = try JSONDecoder().decode(QuizResponse.self, from: jsonData)
            print("Successfully parsed \(quizResponse.questions.count) questions")
            return quizResponse.questions
            
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw QuizError.processingError(decodingError)
        } catch {
            print("Other error: \(error)")
            throw QuizError.processingError(error)
        }
    }
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
                                // Move score increment here
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
