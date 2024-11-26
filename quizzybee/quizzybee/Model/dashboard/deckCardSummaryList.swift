//
//  deckCardSummaryList.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct deckCardSummaryList: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let targetDecks: [Set]
    
    var body: some View {
        
        List {
            ForEach(targetDecks) {
                deckCard in deckCardSummaryRow(deckCard: deckCard)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }.listStyle(.plain)
            .scrollContentBackground(.hidden)
    }
    
}
