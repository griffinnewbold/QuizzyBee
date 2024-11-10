//
//  deckCardSummaryRow.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct deckCardSummaryRow: View {
    var deckCard: DeckCardSummary
    
    var body: some View {
        VStack {
            HStack {
                Text(deckCard.name)
                    .font(.system(size:14))
                    .bold()
                Spacer()
            }
            HStack {
                Text("cards: ")
                    .font(.system(size:10))
                
                Text("\(deckCard.number)")
                    .font(.system(size:10))
                    .foregroundColor(.blue)
                
                Spacer()
            }
        }
    }
}

#Preview {
    Group {
        deckCardSummaryRow(deckCard: decks[0])
        deckCardSummaryRow(deckCard: decks[1])
    }
}
