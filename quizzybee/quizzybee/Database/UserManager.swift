//
//  UserManager.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//

import Foundation
import FirebaseDatabase

class UserManager {
    private let dbRef = Database.database().reference()

    // MARK: - Update Full Name
    func updateFullName(userID: String, newName: String, completion: @escaping (Error?) -> Void) {
        dbRef.child("users").child(userID).child("fullName").setValue(newName) { error, _ in
            completion(error)
        }
    }

    // MARK: - Update Email
    func updateEmail(userID: String, newEmail: String, completion: @escaping (Error?) -> Void) {
        dbRef.child("users").child(userID).child("email").setValue(newEmail) { error, _ in
            completion(error)
        }
    }
    
    // MARK: - Update Profile Image URL
    func updateProfileImageURL(userID: String, newURL: String?, completion: @escaping (Error?) -> Void) {
        dbRef.child("users").child(userID).child("profileImageURL").setValue(newURL) { error, _ in
            completion(error)
        }
    }

    // MARK: - Update User Activity Status
    func updateUserStatus(userID: String, isActive: Bool, completion: @escaping (Error?) -> Void) {
        dbRef.child("users").child(userID).child("isActive").setValue(isActive) { error, _ in
            completion(error)
        }
    }
    
    // MARK: - Update User's Sets
    func updateUserSets(userID: String, newSets: [Set], completion: @escaping (Error?) -> Void) {
        let setsArray = newSets.map { set -> [String: Any] in
            let wordsArray = set.words.map { word -> [String: Any] in
                return ["id": word.id, "term": word.term, "definition": word.definition]
            }
            return ["id": set.id, "title": set.title, "words": wordsArray]
        }
        
        dbRef.child("users").child(userID).child("sets").setValue(setsArray) { error, _ in
            completion(error)
        }
    }
    
    // MARK: - Add a New Set
    func addSetToUser(userID: String, newSet: Set, completion: @escaping (Error?) -> Void) {
        let setDictionary: [String: Any] = [
            "id": newSet.id,
            "title": newSet.title,
            "words": newSet.words.map { ["id": $0.id, "term": $0.term, "definition": $0.definition] }
        ]
        
        dbRef.child("users").child(userID).child("sets").childByAutoId().setValue(setDictionary) { error, _ in
            completion(error)
        }
    }
    
    // MARK: - Add a Word to an Existing Set
    func addWordToSet(userID: String, setID: String, newWord: Word, completion: @escaping (Error?) -> Void) {
        let wordDictionary: [String: Any] = [
            "id": newWord.id,
            "term": newWord.term,
            "definition": newWord.definition
        ]
        
        dbRef.child("users").child(userID).child("sets").child(setID).child("words").childByAutoId().setValue(wordDictionary) { error, _ in
            completion(error)
        }
    }
}
