//
//  Word.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation

struct Word: Codable, Identifiable {
    var id: String
    var term: String
    var definition: String
    
    init(id: String = UUID().uuidString, term: String, definition: String) {
        self.id = id
        self.term = term
        self.definition = definition
    }
    
    // Convert Word to a dictionary
    func toDictionary() -> [String: Any] {
        return ["id": id, "term": term, "definition": definition]
    }
    
    // Initialize Word from a dictionary
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let term = dictionary["term"] as? String,
              let definition = dictionary["definition"] as? String else {
            return nil
        }
        self.id = id
        self.term = term
        self.definition = definition
    }
}

