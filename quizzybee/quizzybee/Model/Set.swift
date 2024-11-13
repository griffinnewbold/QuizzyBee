//
//  Set.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//


//
//  Set.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//


import Foundation

struct Set: Codable, Identifiable {
    var id: String
    var title: String
    var words: [Word]
    
    init(id: String = UUID().uuidString, title: String, words: [Word] = []) {
        self.id = id
        self.title = title
        self.words = words
    }
}
