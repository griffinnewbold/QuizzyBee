//
//  deckCardSummaryRow.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct deckCardSummaryRow: View {
    var deckCard: Set
    
    var body: some View {
        NavigationLink(destination: existingDeckView(set: deckCard)) {
            VStack {
                HStack {
                    Text(deckCard.title)
                        .font(.system(size:14))
                        .bold()
                    Spacer()
                }
                HStack {
                    Text("cards: ")
                        .font(.system(size:10))
                    
                    Text("\(deckCard.words.count)")
                        .font(.system(size:10))
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    Group {
//        deckCardSummaryRow(deckCard: Set(
//            id: "1",
//            title: "Intro to Java",
//            words: [
//                Word(term: "Class", definition: "A blueprint for creating objects"),
//                Word(term: "Object", definition: "An instance of a class")
//            ]
//        ))
//        deckCardSummaryRow(deckCard: Set(
//            id: "2",
//            title: "Data Structures",
//            words: [
//                Word(term: "Array", definition: "A collection of elements"),
//                Word(term: "LinkedList", definition: "A sequence of elements"),
//                Word(term: "Stack", definition: "LIFO data structure")
//            ]
//        ))
//    }
//}
