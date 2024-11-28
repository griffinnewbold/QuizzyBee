//
//  User.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation

struct User: Codable {
    var userID: String
    var fullName: String
    var email: String
    var createdAt: Double
    var sets: [String: Set]
    var profileImage: String
    var voiceModel: String // New property
    
    init(userID: String, fullName: String, email: String, createdAt: Double = Date().timeIntervalSince1970, sets: [String: Set] = [:], profileImage: String = "UserImage1", voiceModel: String = "Default") {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.sets = sets
        self.profileImage = profileImage
        self.voiceModel = voiceModel
    }
    
    // Include "voiceModel" in dictionary conversion
    func toDictionary() -> [String: Any] {
        var userDict = [
            "userID": userID,
            "fullName": fullName,
            "email": email,
            "createdAt": createdAt,
            "sets": sets.mapValues { $0.toDictionary() },
            "profileImage": profileImage
        ] as [String : Any]
        userDict["voiceModel"] = voiceModel
        return userDict
    }
    
    // Initialize User from dictionary with "voiceModel"
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
        self.voiceModel = dictionary["voiceModel"] as? String ?? "Default" // New property
    }
}
