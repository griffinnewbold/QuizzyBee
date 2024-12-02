//
//  Quiz.swift
//  quizzybee
//
//  Created by Tommy Lam on 11/26/24.
//

import Foundation

/// A structure representing a response containing quiz questions.
///
/// - Purpose:
///   - Encapsulates a collection of generated quiz questions.
///   - Designed for decoding JSON responses from a quiz generation API or similar source.
struct QuizResponse: Codable {
    /// The list of generated quiz questions.
    let questions: [GeneratedQuizQuestion]
}

/// A structure representing a single quiz question with its details.
///
/// - Purpose:
///   - Encapsulates the information required for a multiple-choice question.
///   - Includes the question text, answer options, the index of the correct answer, and an explanation.
///
/// - Properties:
///   - `question`: The text of the quiz question.
///   - `options`: An array of answer options.
///   - `correctAnswer`: The index of the correct answer in the `options` array.
///   - `explanation`: A detailed explanation for the correct answer.
struct GeneratedQuizQuestion: Codable {
    /// The text of the quiz question.
    let question: String
    
    /// The answer options for the quiz question.
    let options: [String]
    
    /// The index of the correct answer in the `options` array.
    let correctAnswer: Int
    
    /// A detailed explanation of the correct answer.
    let explanation: String
}
