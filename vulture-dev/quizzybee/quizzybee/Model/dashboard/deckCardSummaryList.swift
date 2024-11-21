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

//#Preview {
//    deckCardSummaryList(targetDecks: [
//        Set(
//            id: "1",
//            title: "Intro to Java",
//            words: [
//                Word(term: "Class", definition: "A blueprint for creating objects"),
//                Word(term: "Object", definition: "An instance of a class")
//            ]
//        ),
//        Set(
//            id: "2",
//            title: "Data Structures",
//            words: [
//                Word(term: "Array", definition: "A collection of elements"),
//                Word(term: "LinkedList", definition: "A sequence of elements"),
//                Word(term: "Stack", definition: "LIFO data structure")
//            ]
//        ),
//        Set(
//            id: "3",
//            title: "Advanced Programming",
//            words: [
//                Word(term: "Design Pattern", definition: "Reusable solution to common problems"),
//                Word(term: "Algorithm", definition: "Step-by-step procedure to solve a problem")
//            ]
//        )
//    ])
//}
