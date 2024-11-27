//
//  Quiz.swift
//  quizzybee
//
//  Created by Tommy Lam on 11/26/24.
//

import Foundation

struct QuizResponse: Codable {
    let questions: [GeneratedQuizQuestion]
}

struct GeneratedQuizQuestion: Codable {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

