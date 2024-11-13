//
//  DeckCardSummary.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import Foundation
import SwiftUI

struct DeckCardSummary: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var number: Int
}
