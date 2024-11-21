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
    
    init(userID: String, fullName: String, email: String, createdAt: Double = Date().timeIntervalSince1970, sets: [String: Set] = [:]) {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.sets = sets
    }
    
    init() {
        self.userID = ""
        self.email = ""
        self.fullName = ""
        self.createdAt = 0.0
        self.sets = [:]
    }
    
    // Convert User to a dictionary
    func toDictionary() -> [String: Any] {
        let setsDict = sets.mapValues { $0.toDictionary() }
        return [
            "userID": userID,
            "fullName": fullName,
            "email": email,
            "createdAt": createdAt,
            "sets": setsDict
        ]
    }
    
    // Initialize User from a dictionary
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
    }
}

