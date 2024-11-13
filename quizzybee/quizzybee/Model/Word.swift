//
//  Word.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//


//
//  Word.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//


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
