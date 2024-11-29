//
//  Word.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation

struct Word: Codable, Identifiable, Equatable, Hashable {
    var id: String
    var term: String
    var definition: String
    var color: String
    
    init(id: String = UUID().uuidString, term: String, definition: String, color: String) {
        self.id = id
        self.term = term
        self.definition = definition
        self.color = color
    }
    
    // Convert Word to a dictionary
    func toDictionary() -> [String: Any] {
        return ["id": id, "term": term, "definition": definition, "color": color]
    }
    
    // Initialize Word from a dictionary
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let term = dictionary["term"] as? String,
              let definition = dictionary["definition"] as? String,
            let color = dictionary["color"] as? String else {
            return nil
        }
        self.id = id
        self.term = term
        self.definition = definition
        self.color = color
    }
}

