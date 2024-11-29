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
            ForEach(targetDecks, id: \.id) {
                deckCard in deckCardSummaryRow(deckCard: deckCard)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            authViewModel.deleteDeck(setId: deckCard.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
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
