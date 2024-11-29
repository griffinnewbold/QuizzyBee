//
//  Word.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation

struct Word: Codable, Identifiable, Equatable, Hashable {
    var id: String
    /// The word or term.
    var term: String
    /// The definition of the word.
    var definition: String
    /// The color associated with the word, represented as a string (e.g., a hex color code).
    var color: String

    // MARK: - Initializers
    /// Initializes a new `Word` instance.
    /// - Parameters:
    ///   - id: The unique identifier for the word. Defaults to a new UUID string.
    ///   - term: The word or term.
    ///   - definition: The definition of the word.
    ///   - color: The color associated with the word.
    init(id: String = UUID().uuidString, term: String, definition: String, color: String) {
        self.id = id
        self.term = term
        self.definition = definition
        self.color = color
    }

    /// Initializes a `Word` instance from a dictionary representation.
    /// - Parameter dictionary: A dictionary containing the word's data.
    /// - Returns: A `Word` instance if the dictionary contains valid data, or `nil` if the data is invalid.
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

    // MARK: - Methods
    /// Converts the `Word` instance into a dictionary representation.
    /// - Returns: A dictionary containing the word's data.
    func toDictionary() -> [String: Any] {
        return ["id": id, "term": term, "definition": definition, "color": color]
    }
}
