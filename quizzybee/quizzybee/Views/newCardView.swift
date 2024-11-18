//
//  newCardView.swift
//  quizzybee
//  Created by Madeleine on 2024/11/8.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct Flashcard {
    var frontText: String
    var backText: String
}

struct newCardView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentCardIndex = 0
    @State private var words = [
        Word(term: "", definition: "")
    ]
    @State private var deckTitle = "New Deck Title"
    @State private var set = Set(title: "")
    
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
                    
                    ZStack(alignment: .trailing) {
                        TextField("Enter Deck Title", text: $deckTitle)
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Image(systemName: "pencil")
                            .foregroundColor(.black)
                            .offset(x: -50)
                    }
                    
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
                                TextEditor(text: $words[currentCardIndex].term)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .frame(width: 300, height: 160)
                                
                                if words[currentCardIndex].term.isEmpty {
                                    Text("Question here...")
                                        .foregroundColor(.gray)
                                        .padding(10)
                                        .frame(width: 300, height: 160, alignment: .topLeading)
                                        .opacity(0.6)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Answer (Back)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            ZStack {
                                TextEditor(text: $words[currentCardIndex].definition)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .frame(width: 300, height: 160)
                                
                                if words[currentCardIndex].definition.isEmpty {
                                    Text("Answer here...")
                                        .foregroundColor(.gray)
                                        .padding(10)
                                        .frame(width: 300, height: 160, alignment: .topLeading)
                                        .opacity(0.6)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentCardIndex == words.count - 1 {
                            let newWord = Word(term: "", definition: "")
                            words.append(newWord)
                        }
                        currentCardIndex += 1
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    set.title = deckTitle
                    set.words = words
                    saveSetForCurrentUser(set: set)
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
    
    func saveSetForCurrentUser(set: Set) {
        if let user = Auth.auth().currentUser {
            let userID = user.uid
            saveSetForUser(userID: userID, set: set)
        } else {
            print("User not logged in.")
        }
    }
    
    func saveSetForUser(userID: String, set: Set) {
        let ref = Database.database().reference()
        let userSetsRef = ref.child("users").child(userID).child("sets").child(set.id)
        
        let setDictionary: [String: Any] = [
            "id": set.id,
            "title": set.title,
            "words": set.words.map { word in
                return [
                    "id": word.id,
                    "term": word.term,
                    "definition": word.definition
                ]
            }
        ]
        
        userSetsRef.setValue(setDictionary) { error, _ in
            if let error = error {
                print("Error saving set to Firebase: \(error)")
            } else {
                print("Successfully saved set to Firebase.")
            }
        }
    }
}

#Preview {
    newCardView()
}
