//
//  Set.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation

/// Represents a set of flashcards containing words and their definitions.
struct Set: Codable, Identifiable, Equatable, Hashable {
    // MARK: - Properties

    /// The unique identifier of the set.

    var id: String
    /// The title of the set.
    var title: String
    /// The list of words in the set.
    var words: [Word]

    // MARK: - Initializers
    /// Initializes a new `Set` instance.
    /// - Parameters:
    ///   - id: The unique identifier for the set. Defaults to a new UUID string.
    ///   - title: The title of the set.
    ///   - words: An array of `Word` objects in the set. Defaults to an empty array.
    init(id: String = UUID().uuidString, title: String, words: [Word] = []) {
        self.id = id
        self.title = title
        self.words = words
    }

    /// Initializes a `Set` from a dictionary.
    /// - Parameter dictionary: A dictionary representation of the `Set`.
    /// - Returns: A `Set` instance if the dictionary contains valid data, or `nil` if the data is invalid.
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

    // MARK: - Methods
    /// Converts the `Set` instance into a dictionary.
    /// - Returns: A dictionary representation of the `Set`.
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "words": words.map { $0.toDictionary() }
        ]
    }
}
