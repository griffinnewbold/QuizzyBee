//
//  User.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//


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
    var sets: [Set]
    
    init(userID: String, fullName: String, email: String, createdAt: Double = Date().timeIntervalSince1970, sets: [Set] = []) {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.sets = sets
    }
    
    func toDictionary() -> [String: Any] {
        let setsArray = sets.map { set -> [String: Any] in
            let wordsArray = set.words.map { word -> [String: Any] in
                return ["id": word.id, "term": word.term, "definition": word.definition]
            }
            return ["id": set.id, "title": set.title, "words": wordsArray]
        }
        
        return [
            "userID": userID,
            "fullName": fullName,
            "email": email,
            "sets": setsArray,
            "createdAt": createdAt,
        ]
    }
}
