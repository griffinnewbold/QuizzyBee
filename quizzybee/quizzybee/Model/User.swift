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
    
    init(userID: String, fullName: String, email: String, createdAt: Double = Date().timeIntervalSince1970, sets: [String: Set] = [:], profileImage: String = "UserImage1") {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.sets = sets
        self.profileImage = profileImage
    }
    
    init() {
        self.userID = ""
        self.email = ""
        self.fullName = ""
        self.createdAt = 0.0
        self.sets = [:]
        self.profileImage = "UserImage1"
    }
    
    // Convert User to a dictionary
    func toDictionary() -> [String: Any] {
        let setsDict = sets.mapValues { $0.toDictionary() }
        return [
            "userID": userID,
            "fullName": fullName,
            "email": email,
            "createdAt": createdAt,
            "sets": setsDict,
            "profileImage": profileImage
        ]
    }
    
    // Initialize User from a dictionary
    init?(dictionary: [String: Any]) {
        guard let userID = dictionary["userID"] as? String,
              let fullName = dictionary["fullName"] as? String,
              let email = dictionary["email"] as? String,
              let createdAt = dictionary["createdAt"] as? Double,
              let setsDict = dictionary["sets"] as? [String: [String: Any]]
        else {
            return nil
        }
        
        let profileImage = dictionary["profileImage"] as? String ?? "UserImage1"
        
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.sets = setsDict.compactMapValues { Set(dictionary: $0)}
        self.profileImage = profileImage
    }
}

