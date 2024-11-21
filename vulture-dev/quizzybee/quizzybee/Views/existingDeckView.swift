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

    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
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
                            // Settings action here
                        }) {
                            Image(systemName: "gear")
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
                    
                    // Flashcards
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
                            Text(showAnswer ? answers[safe: currentQuestionIndex] ?? "No answer available" : questions[safe: currentQuestionIndex] ?? "No question available")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding()
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onTapGesture {
                            showAnswer.toggle()
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
                    
                    // Flashcard Pages
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
                    
                    // Add New Card
                    NavigationLink(destination: newCardView().navigationBarBackButtonHidden(true)) {
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
                    
                    // Start Review
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
                    
                    // Start Quiz
                    NavigationLink(destination: quizView().navigationBarBackButtonHidden(true)) {
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
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
            .onAppear {
                fetchFlashcards(forSet: set)
            }
        }
    }

    // Function to Fetch Flashcards from Firebase
     func fetchFlashcards(forSet set: Set) {
         guard let user = Auth.auth().currentUser else {
             print("User not logged in.")
             return
         }
         
         let userID = user.uid
         let ref = Database.database().reference()
         let userSetRef = ref.child("users").child(userID).child("sets").child(set.id).child("words")
         
         // Observe for real-time updates
         userSetRef.observe(.value) { snapshot in
             guard let wordsDict = snapshot.value as? [String: Any] else {
                 print("No flashcards found for this set.")
                 self.questions = []
                 self.answers = []
                 return
             }
             
             let flashcards = wordsDict.compactMap { (_, value) -> (String, String)? in
                 guard let wordData = value as? [String: Any],
                       let term = wordData["term"] as? String,
                       let definition = wordData["definition"] as? String else {
                     return nil
                 }
                 return (term, definition)
             }
             
             self.questions = flashcards.map { $0.0 }
             self.answers = flashcards.map { $0.1 }
             
             if !flashcards.isEmpty {
                 self.currentQuestionIndex = 0
             }
         }
     }

}

//prevent crashes due to out-of-bounds array access
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    existingDeckView(set: Set(
        id: "1",
        title: "Intro to Java",
        words: [
            Word(term: "", definition: "", color: "#FFFFFF")
        ]
    ))
}
