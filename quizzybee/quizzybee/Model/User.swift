//
//  User.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation

/// Represents a user in the Quizzybee application.
struct User: Codable {
    // MARK: - Properties
    /// The unique identifier of the user.
    var userID: String
    /// The full name of the user.
    var fullName: String
    /// The email address of the user.
    var email: String
    /// The timestamp representing the account creation date, stored as seconds since 1970.
    var createdAt: Double
    /// A dictionary of the user's sets, where the key is the set ID and the value is the `Set` object.
    var sets: [String: Set]
    /// The profile image associated with the user.
    /// Defaults to `"UserImage1"` if not specified.
    var profileImage: String
    /// The selected voice model for text-to-speech functionality.
    /// Defaults to `"Default"` if not specified.
    var voiceModel: String
    
    // MARK: - Initializers
    /// Initializes a new `User` instance with the given properties.
    /// - Parameters:
    ///   - userID: The unique identifier for the user.
    ///   - fullName: The full name of the user.
    ///   - email: The email address of the user.
    ///   - createdAt: The account creation date as seconds since 1970. Defaults to the current timestamp.
    ///   - sets: A dictionary of the user's sets. Defaults to an empty dictionary.
    ///   - profileImage: The profile image name. Defaults to `"UserImage1"`.
    ///   - voiceModel: The selected voice model. Defaults to `"Default"`.
    init(userID: String, fullName: String, email: String, createdAt: Double = Date().timeIntervalSince1970, sets: [String: Set] = [:], profileImage: String = "UserImage1", voiceModel: String = "Default") {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.sets = sets
        self.profileImage = profileImage
        self.voiceModel = voiceModel
    }

    /// Initializes a `User` instance from a dictionary representation.
    /// - Parameter dictionary: A dictionary containing the user data.
    /// - Returns: A `User` instance if the dictionary contains valid data, or `nil` if the data is invalid.
    init?(dictionary: [String: Any]) {
        guard let userID = dictionary["userID"] as? String,
              let fullName = dictionary["fullName"] as? String,
              let email = dictionary["email"] as? String,
              let createdAt = dictionary["createdAt"] as? Double,
              let setsDict = dictionary["sets"] as? [String: [String: Any]] else {
            return nil
        }
        
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.sets = setsDict.compactMapValues { Set(dictionary: $0) }
        self.profileImage = dictionary["profileImage"] as? String ?? "UserImage1"
        self.voiceModel = dictionary["voiceModel"] as? String ?? "Default"
    }

    // MARK: - Methods
    /// Converts the `User` instance into a dictionary representation.
    /// - Returns: A dictionary containing the user's data.
    func toDictionary() -> [String: Any] {
        var userDict: [String: Any] = [
            "userID": userID,
            "fullName": fullName,
            "email": email,
            "createdAt": createdAt,
            "sets": sets.mapValues { $0.toDictionary() },
            "profileImage": profileImage
        ]
        userDict["voiceModel"] = voiceModel
        return userDict
    }
}
