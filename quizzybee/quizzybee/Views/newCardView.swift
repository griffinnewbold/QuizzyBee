//
//  newCardView.swift
//  quizzybee
//
//  Created by Madeleine on 2024/11/8.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

/// A view that allows users to create or edit flashcards in a deck.
///
/// Users can:
/// - Add new cards to a deck.
/// - Edit card content (question and answer).
/// - Change card background colors.
/// - Save the deck to Firebase or append new cards to an existing deck.
///
/// - Parameters:
///   - `existingDeckID`: An optional `String` representing the ID of an existing deck to add cards to.
///   - `networkMonitor`: Monitors internet connectivity to ensure Firebase operations are valid.
struct newCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @State private var currentCardIndex = 0
    @State private var words = [
        Word(term: "", definition: "", color: "#FFFFFF") // Default white card
    ]
    @State private var deckTitle = "Add Cards"
    @State private var set = Set(title: "")
    @State private var showingColorPicker = false
    @State private var showingAlert = false
    
    /// The ID of an existing deck to add cards to, if applicable.
    var existingDeckID: String?
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            VStack {
                // MARK: Navigation Bar
                HStack {
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // Deck Title Editor
                    ZStack(alignment: .trailing) {
                        TextField("Enter Deck Title", text: $deckTitle)
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .disabled(existingDeckID != nil) // Disable editing for existing decks
                        
                        if existingDeckID == nil {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                                .offset(x: -50)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // MARK: Main Card Editor
                HStack {
                    // Previous Card Button
                    Button(action: { navigateToPreviousCard() }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // Card Content Editor
                    cardEditorView()
                    
                    Spacer()
                    
                    // Next Card Button
                    Button(action: { navigateToNextCard() }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                
                // MARK: Change Card Color Button
                Button(action: { showingColorPicker.toggle() }) {
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
                
                // MARK: Save Deck Button
                Button(action: { handleSaveAction() }) {
                    Text(existingDeckID == nil ? "Save Deck" : "Add to this Deck")
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
        .sheet(isPresented: $showingColorPicker) { colorPickerSheet() }
        .alert(isPresented: $showingAlert) { noInternetAlert() }
    }
    
    // MARK: - Navigation
    /// Navigates to the previous card in the deck.
    private func navigateToPreviousCard() {
        if currentCardIndex > 0 {
            currentCardIndex -= 1
        }
    }
    
    /// Navigates to the next card in the deck.
    private func navigateToNextCard() {
        if currentCardIndex == words.count - 1 {
            words.append(Word(term: "", definition: "", color: "#FFFFFF"))
        }
        currentCardIndex += 1
    }
    
    // MARK: - Card Editor
    /// Builds the card content editor view.
    private func cardEditorView() -> some View {
        VStack(spacing: 20) {
            // Term (Front)
            VStack(alignment: .leading) {
                Text("Question (Front)")
                    .font(.headline)
                    .foregroundColor(.black)
                
                TextEditor(text: $words[currentCardIndex].term)
                    .editorStyle(for: words[currentCardIndex].color, placeholder: "Question here...")
            }
            
            // Definition (Back)
            VStack(alignment: .leading) {
                Text("Answer (Back)")
                    .font(.headline)
                    .foregroundColor(.black)
                
                TextEditor(text: $words[currentCardIndex].definition)
                    .editorStyle(for: words[currentCardIndex].color, placeholder: "Answer here...")
            }
        }
    }
    
    // MARK: - Save Action
    /// Handles the save or append action based on whether the deck is new or existing.
    private func handleSaveAction() {
        guard networkMonitor.isConnected else {
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
    }
    
    // MARK: - Firebase Operations
    /// Saves the set for the current user in Firebase.
    private func saveSetForCurrentUser(set: Set) {
        guard let user = Auth.auth().currentUser else { return }
        saveSetForUser(userID: user.uid, set: set)
    }
    
    /// Saves the set for a specific user in Firebase.
    private func saveSetForUser(userID: String, set: Set) {
        let ref = Database.database().reference()
        let userSetsRef = ref.child("users").child(userID).child("sets").child(set.id)
        
        userSetsRef.setValue(set.toDictionary()) { error, _ in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name("RefreshDashboard"), object: nil)
            }
        }
    }
    
    /// Appends new cards to an existing deck in Firebase.
    private func appendCardsToExistingDeck() {
        guard let user = Auth.auth().currentUser, let deckID = existingDeckID else { return }
        let wordsRef = Database.database().reference()
            .child("users").child(user.uid).child("sets").child(deckID).child("words")
        
        wordsRef.observeSingleEvent(of: .value) { snapshot in
            var existingWords = (snapshot.value as? [[String: Any]]) ?? []
            existingWords.append(contentsOf: words.map { $0.toDictionary() })
            wordsRef.setValue(existingWords)
        }
    }
    
    // MARK: - Alerts
    /// Displays an alert when there is no internet connection.
    private func noInternetAlert() -> Alert {
        Alert(
            title: Text("No Internet Connection"),
            message: Text("Please check your internet connection and try again."),
            dismissButton: .default(Text("OK"))
        )
    }
    
    // MARK: - Color Picker Sheet
    /// Builds the color picker sheet view.
    private func colorPickerSheet() -> some View {
        VStack {
            Text("Pick a Color for the Card Background")
                .font(.headline)
            
            ColorPicker("Select Color", selection: Binding(
                get: { Color(hex: words[currentCardIndex].color) },
                set: { newColor in
                    words[currentCardIndex].color = newColor.toHex() ?? "#FFFFFF"
                }
            ))
        }
    }
}

// MARK: - View Extensions
extension View {
    /// Configures a consistent style for card editors.
    func editorStyle(for color: String, placeholder: String) -> some View {
        self
            .font(.body)
            .foregroundColor(.black)
            .padding(10)
            .background(Color(hex: color))
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(width: 300, height: 160)
            .overlay(
                Group {
                    if placeholder.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(20)
                            .opacity(0.6)
                    }
                }
            )
    }
}
