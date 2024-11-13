import Foundation

struct Word: Codable, Identifiable {
    var id: String
    var term: String
    var definition: String
    
    init(id: String = UUID().uuidString, term: String, definition: String) {
        self.id = id
        self.term = term
        self.definition = definition
    }
}
