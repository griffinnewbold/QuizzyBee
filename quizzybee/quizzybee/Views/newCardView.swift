//
//  newCardView.swift
//  quizzybee
//
//  Created by Madeleine on 2024/11/8.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct Flashcard {
    var frontText: String
    var backText: String
    var color: String
}

struct newCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @State private var currentCardIndex = 0
    @State private var words = [
        Word(term: "", definition: "", color: "#FFFFFF") // Default white color
    ]
    @State private var deckTitle = "New Deck Title"
    @State private var set = Set(title: "")
    @State private var showingColorPicker = false
    @State private var showingAlert = false
    
    var existingDeckID: String? // Optional parameter for the existing deck ID
    var shouldShowTitle: Bool = true
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    if shouldShowTitle {
                        ZStack(alignment: .trailing) {
                            TextField("Enter Deck Title", text: $deckTitle)
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .disabled(existingDeckID != nil) // Disable title editing for existing decks
                            
                            if existingDeckID == nil {
                                Image(systemName: "pencil")
                                    .foregroundColor(.black)
                                    .offset(x: -50)
                            }
                        }
                    }

                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // Main Card Editor
                HStack {
                    // Previous Card Button
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
                        // Term (Front)
                        VStack(alignment: .leading) {
                            Text("Question (Front)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            TextEditor(text: $words[currentCardIndex].term)
                                .font(.body)
                                .foregroundColor(.black)  // Text color
                                .padding(10)
                                .background(Color(hex: words[currentCardIndex].color))  // Card background color
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .frame(width: 300, height: 160)
                                .overlay(
                                    Group {
                                        if words[currentCardIndex].term.isEmpty {
                                            Text("Question here...")
                                                .foregroundColor(.gray)
                                                .padding(20)
                                                .frame(width: 300, height: 160, alignment: .topLeading)
                                                .opacity(0.6)
                                        }
                                    }
                                )
                        }
                        
                        // Definition (Back)
                        VStack(alignment: .leading) {
                            Text("Answer (Back)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            TextEditor(text: $words[currentCardIndex].definition)
                                .font(.body)
                                .foregroundColor(.black)  // Text color
                                .padding(10)
                                .background(Color(hex: words[currentCardIndex].color))  // Card background color
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .frame(width: 300, height: 160)
                                .overlay(
                                    Group {
                                        if words[currentCardIndex].definition.isEmpty {
                                            Text("Answer here...")
                                                .foregroundColor(.gray)
                                                .padding(20)
                                                .frame(width: 300, height: 160, alignment: .topLeading)
                                                .opacity(0.6)
                                        }
                                    }
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // Next Card Button
                    Button(action: {
                        if currentCardIndex == words.count - 1 {
                            let newWord = Word(term: "", definition: "", color: "#FFFFFF") // Default color
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

                // Change Card Color Button
                Button(action: {
                    // Toggle the visibility of the color picker
                    showingColorPicker.toggle()
                }) {
                    Text("Change Card Color")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                // Save Deck Button (Moved here)
                Button(action: {
                    
                    if !networkMonitor.isConnected {
                        print("Cannot save deck, no internet connection.")
                        showingAlert = true
                        return
                    }
                    
                    if existingDeckID == nil {
                        set.title = deckTitle
                        set.words = words
                        saveSetForCurrentUser(set: set)
                    } else {
                        appendCardsToExistingDeck()
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(existingDeckID == nil ? "Save Deck" : "Add to this Deck")// change while add card to existing deck
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingColorPicker) {
            // Color Picker Sheet
            VStack {
                Text("Pick a Color for the Card Background")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 8)
                
                ColorPicker("Select Color", selection: Binding(
                    get: {
                        Color(hex: words[currentCardIndex].color)
                    },
                    set: { newColor in
                        words[currentCardIndex].color = newColor.toHex() ?? "#FFFFFF"
                    }
                ))
                .padding()
                
                Button("Done") {
                    // Close the color picker sheet
                    showingColorPicker = false
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top)
            }
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("No Internet Connection"),
                message: Text("Please check your internet connection and try again."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            if existingDeckID != nil {
                fetchDeckTitle()
            }
        }
    }
    
    func fetchDeckTitle() {
        guard let user = Auth.auth().currentUser, let existingDeckID = existingDeckID else { return }
        let userID = user.uid
        let ref = Database.database().reference()
        let deckRef = ref.child("users").child(userID).child("sets").child(existingDeckID).child("title")
        
        deckRef.observeSingleEvent(of: .value) { snapshot in
            if let title = snapshot.value as? String {
                DispatchQueue.main.async {
                    self.deckTitle = title
                }
            } else {
                print("Failed to fetch deck title.")
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
                    "definition": word.definition,
                    "color": word.color
                ]
            }
        ]
        
        userSetsRef.setValue(setDictionary) { error, _ in
            if let error = error {
                print("Error saving set to Firebase: \(error)")
            } else {
                print("Successfully saved set to Firebase.")
                
                // need to refresh dashboard
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshDashboard"), object: nil)
                }
            }
        }
    }
    
    func appendCardsToExistingDeck() {
        guard let user = Auth.auth().currentUser, let existingDeckID = existingDeckID else { return }
        let userID = user.uid
        let ref = Database.database().reference()
        let wordsRef = ref.child("users").child(userID).child("sets").child(existingDeckID).child("words")
        
        wordsRef.observeSingleEvent(of: .value) { snapshot in
            // Retrieve existing words
            var updatedWords = [[String: Any]]()
            if let existingWords = snapshot.value as? [[String: Any]] {
                updatedWords = existingWords
            }
            
            // Prepare new words
            let newWords = words.map { word in
                return [
                    "id": UUID().uuidString, // Generate a unique ID for each word
                    "term": word.term,
                    "definition": word.definition,
                    "color": word.color
                ]
            }
            
            // Append new words to existing words
            updatedWords.append(contentsOf: newWords)
            
            // Save back to Firebase
            wordsRef.setValue(updatedWords) { error, _ in
                if let error = error {
                    print("Error appending cards to deck: \(error)")
                } else {
                    print("Successfully added new cards to the existing deck.")
                    
                    // need to refresh dashboard
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshDashboard"), object: nil)
                    }

                }
            }
        }
    }
}

#Preview {
    newCardView()
}
