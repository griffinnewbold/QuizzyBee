//
//  existingDeckView.swift
//  quizzybee
//
//  Created by Chiapeng Wu on 2024/11/12.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct existingDeckView: View {
    let set: Set
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentQuestionIndex = 0
    @State private var searchText = ""
    @State private var showAnswer = false
    @State private var questions: [String] = []
    @State private var answers: [String] = []
    @State private var isLoading = true // Track loading state
    
    // text-to-speech
    @StateObject private var speech = textToSpeech()
    @State private var isPlaying = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Top Bar
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                        Text(set.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            // Settings action
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        TextField("Search keyword", text: $searchText)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            if !searchText.isEmpty {
                                if let index = questions.firstIndex(where: { $0.localizedCaseInsensitiveContains(searchText) }) {
                                    currentQuestionIndex = index
                                    showAnswer = false
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Main Content
                    if isLoading {
                        // Loading State
                        ProgressView("Loading...")
                            .scaleEffect(1.5)
                            .padding()
                    } else if questions.isEmpty {
                        // No Data State
                        VStack {
                            Text("No flashcards available.")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Reload") {
                                isLoading = true
                                fetchFlashcards(forSet: set)
                            }
                            .foregroundColor(.blue)
                            .padding()
                        }
                    } else {
                        // Flashcard Interaction
                        HStack {
                            Button(action: {
                                if currentQuestionIndex > 0 {
                                    currentQuestionIndex -= 1
                                    showAnswer = false
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            
                            VStack {
                                Text(showAnswer ? answers[safe: currentQuestionIndex] ?? "No answer available":questions[safe: currentQuestionIndex] ?? "No question available")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .font(.title3)
                                    .foregroundColor(.black)
                                
                                // MARK: text to speech
                                Button(action: {
                                    let textToSpeak = showAnswer ?
                                    (answers[safe: currentQuestionIndex] ?? "") :
                                    (questions[safe: currentQuestionIndex] ?? "")
                                    isPlaying.toggle()
                                    if isPlaying {
                                        speech.speak(textToSpeak)
                                    } else {
                                        speech.stop()
                                    }
                                }) {
                                    Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .onTapGesture {
                                showAnswer.toggle()
                                isPlaying = false
                                speech.stop()
                            }
                            .onChange(of: currentQuestionIndex) { _ in
                                isPlaying = false
                                speech.stop()
                            }
                            
                            Button(action: {
                                if currentQuestionIndex < questions.count - 1 {
                                    currentQuestionIndex += 1
                                    showAnswer = false
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .padding()
                            }
                        }
                        
                        // Flashcard Navigation Indicators
                        HStack(spacing: 8) {
                            ForEach(questions.indices, id: \.self) { index in
                                Circle()
                                    .fill(index == currentQuestionIndex ? Color.black : Color.gray)
                                    .frame(width: 10, height: 10)
                                    .onTapGesture {
                                        currentQuestionIndex = index
                                        showAnswer = false
                                    }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(100)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 10) {
                        NavigationLink(destination: newCardView(existingDeckID: set.id).navigationBarBackButtonHidden(true)) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            .padding()
                            .frame(height: 60)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(destination: reviewView(questions: $questions, answers: $answers)) {
                            HStack {
                                Spacer()
                                Text("Start Review")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding()
                            .frame(height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(destination: quizView(
                            deckTitle: set.title,
                            apiKey: "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",
                            questions: $questions,
                            answers: $answers).navigationBarBackButtonHidden(true)) {
                            HStack {
                                Spacer()
                                Text("Start Quiz")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding()
                            .frame(height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
            .onAppear {
                isLoading = true
                fetchFlashcards(forSet: set)
            }
        }
    }

    // Function to Fetch Flashcards from Firebase
    func fetchFlashcards(forSet set: Set) {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            self.isLoading = false
            return
        }
        
        let userID = user.uid
        let ref = Database.database().reference()
        let userSetRef = ref.child("users").child(userID).child("sets").child(set.id).child("words")
        
        userSetRef.observeSingleEvent(of: .value) { snapshot in
            defer { self.isLoading = false } // Ensure loading state stops
            
            guard let wordsArray = snapshot.value as? [[String: Any]] else {
                print("No flashcards found for this set or invalid format.")
                self.questions = []
                self.answers = []
                return
            }
            
            self.questions = wordsArray.compactMap { $0["term"] as? String }
            self.answers = wordsArray.compactMap { $0["definition"] as? String }
            
            if !self.questions.isEmpty {
                self.currentQuestionIndex = 0
            }
        }
    }
}

// Prevent crashes due to out-of-bounds array access
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//#Preview {
//    existingDeckView(set: Set(
//        id: "1",
//        title: "Intro to Java",
//        words: [
//            Word(term: "", definition: "", color: "#FFFFFF")
//        ]
//    ))
//}
