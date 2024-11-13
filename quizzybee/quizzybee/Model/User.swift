import Foundation

struct User: Codable {
    var userID: String
    var fullName: String
    var email: String
    var createdAt: Double
    var profileImageURL: String?
    var isActive: Bool
    var sets: [Set]
    
    init(userID: String, fullName: String, email: String, createdAt: Double = Date().timeIntervalSince1970, profileImageURL: String? = nil, isActive: Bool = true, sets: [Set] = []) {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.createdAt = createdAt
        self.profileImageURL = profileImageURL
        self.isActive = isActive
        self.sets = sets
    }
    
    // Convert to dictionary for Firebase
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
            "createdAt": createdAt,
            "profileImageURL": profileImageURL ?? "",
            "isActive": isActive,
            "sets": setsArray
        ]
    }
}
