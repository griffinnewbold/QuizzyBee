//
//  Set.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation

struct Set: Codable, Identifiable, Equatable {
    var id: String
    var title: String
    var words: [Word]
    
    init(id: String = UUID().uuidString, title: String, words: [Word] = []) {
        self.id = id
        self.title = title
        self.words = words
    }
    
    // Convert Set to a dictionary
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "words": words.map { $0.toDictionary() }
        ]
    }
    
    // Initialize Set from a dictionary
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let wordsArray = dictionary["words"] as? [[String: Any]] else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.words = wordsArray.compactMap { Word(dictionary: $0) }
    }
}
