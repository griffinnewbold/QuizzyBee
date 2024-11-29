//
//  addNewCard.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct addNewDeck: View {
    @State private var addNewDeck = false
    
    var body: some View {
        Button {
            addNewDeck = true
        } label: {
            VStack {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    Text("Add A New Deck")
                        .font(.system(size: 14))
                        .bold()
                        .foregroundStyle(.black)
                }
            }
            .padding()
            .frame(width: 370)
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .sheet(isPresented: $addNewDeck) {
            newCardView()
        }
    }
}
