//
//  newCardView.swift
//  quizzybee
//
//  Created by maddie on 11/6/24.
//

import SwiftUI

struct Flashcard {
    var frontText: String
    var backText: String
}

struct newCardView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentCardIndex = 0
    @State private var flashcards = [
        Flashcard(frontText: "", backText: ""),
        Flashcard(frontText: "", backText: ""),
        Flashcard(frontText: "", backText: "")
    ]
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("{New Deck Title}")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        if currentCardIndex > 0 {
                            currentCardIndex -= 1
                        }
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()

                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Question (Front)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            ZStack {
                                TextEditor(text: $flashcards[currentCardIndex].frontText)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .frame(width: 240, height: 120)
                                

                                if flashcards[currentCardIndex].frontText.isEmpty {
                                    Text("Question here...")
                                        .foregroundColor(.gray)
                                        .padding(10)
                                        .frame(width: 240, height: 120, alignment: .topLeading)
                                        .opacity(0.6)
                                }
                            }
                        }
                        

                        VStack(alignment: .leading) {
                            Text("Answer (Back)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            ZStack {
                                TextEditor(text: $flashcards[currentCardIndex].backText)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .frame(width: 240, height: 120)
                                
                                
                                if flashcards[currentCardIndex].backText.isEmpty {
                                    Text("Answer here...")
                                        .foregroundColor(.gray)
                                        .padding(10)
                                        .frame(width: 240, height: 120, alignment: .topLeading)
                                        .opacity(0.6)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentCardIndex < flashcards.count - 1 {
                            currentCardIndex += 1
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                

                Button(action: {
                    saveFlashcards()
                }) {
                    Text("Save Deck")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
    }
    

    func saveFlashcards() {
        print("Saving flashcards: \(flashcards)")
        // add saving logic here (database)
        // to be implemented
    }
}

#Preview {
    newCardView()
}