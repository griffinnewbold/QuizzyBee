//
//  OpenAIService.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/26/24.
//

import Foundation

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

enum QuizError: Error, LocalizedError {
    case invalidResponse
    case noContent
    case invalidJSON
    case apiError(String)
    case processingError(Error)
    case invalidQuestionCount
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Failed to get a valid response from OpenAI."
        case .noContent:
            return "No content received from OpenAI."
        case .invalidJSON:
            return "Failed to parse response as JSON."
        case .apiError(let message):
            return "API Error: \(message)"
        case .processingError(let error):
            return "Error processing response: \(error.localizedDescription)"
        case .invalidQuestionCount:
            return "Invalid number of questions requested. Must be between 1 and 20."
        }
    }
}

// MARK: - OpenAI Service
class OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // Generic function to send a prompt to OpenAI API
    func sendPrompt(prompt: String, systemRole: String = "You are an assistant.") async throws -> String {
        let messages: [[String: Any]] = [
            ["role": "system", "content": systemRole],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "temperature": 0.7
        ]
        
        do {
            var request = URLRequest(url: URL(string: baseURL)!)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("API Error Response: \(rawResponse)")
                }
                throw QuizError.invalidResponse
            }
            
            let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            guard let content = openAIResponse.choices.first?.message.content else {
                throw QuizError.noContent
            }
            
            return content
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw QuizError.processingError(decodingError)
        } catch {
            print("Error: \(error)")
            throw QuizError.processingError(error)
        }
    }
}

// MARK: - Quiz-Specific Extension
extension OpenAIService {
    func generateQuiz(basedOn questions: [String], questionCount: Int = 5) async throws -> [GeneratedQuizQuestion] {
        // Validate question count
        guard questionCount > 0 && questionCount <= 20 else {
            throw QuizError.invalidQuestionCount
        }
        
        let prompt = """
        Generate \(questionCount) multiple choice questions related to these topics: \(questions.joined(separator: ", "))
        
        Follow these rules:
        1. Each question should test understanding of the topics
        2. Include 4 options for each question
        3. Options should be clear and distinct
        4. Provide a brief explanation for the correct answer
        
        Respond with a JSON object in this exact format:
        {
            "questions": [
                {
                    "question": "question text",
                    "options": ["option1", "option2", "option3", "option4"],
                    "correctAnswer": integer_index,
                    "explanation": "explanation text"
                }
            ]
        }
        
        Generate exactly \(questionCount) questions.
        """
        
        let response = try await sendPrompt(
            prompt: prompt,
            systemRole: "You are a quiz generator specialized in creating educational multiple-choice questions."
        )
        
        guard let jsonData = response.data(using: .utf8) else {
            throw QuizError.invalidJSON
        }
        
        let quizResponse = try JSONDecoder().decode(QuizResponse.self, from: jsonData)
        return quizResponse.questions
    }
}
