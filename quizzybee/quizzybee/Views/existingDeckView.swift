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
    let openAIAPIKey: String = "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"
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentQuestionIndex = 0
    @State private var searchText = ""
    @State private var showAnswer = false
    @State private var questions: [String] = []
    @State private var answers: [String] = []
    @State private var colors: [String] = []
    @State private var isLoading = true // Track loading state
    
    // Text-to-speech
    @StateObject private var speech = textToSpeech()
    @State private var isPlaying = false
    

    @State private var selectedQuestion: String = "" // Added to hold the question for editing
    @State private var selectedAnswer: String = ""   // Added to hold the answer for editing
    @State private var selectedColor: String = ""   // Added to hold the color for editing
    @State private var showEditView = false         // Toggle to show editCardView
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Top Bar
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .padding()
                        }
                        Spacer()
                        Text(set.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        //Edit current flashcard
                        Button(action: {
                            if let question = questions[safe: currentQuestionIndex],
                               let answer = answers[safe: currentQuestionIndex],
                               let color = colors[safe: currentQuestionIndex] {
                                selectedQuestion = question
                                selectedAnswer = answer
                                selectedColor = color
                                // Show editCurrentCardView
                                showEditView = true
                            }
                        }) {
                            Text("Edit")
                                .foregroundColor(.black)
                                .font(.headline)
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
                                Text(showAnswer ? answers[safe: currentQuestionIndex] ?? "No answer available" : questions[safe: currentQuestionIndex] ?? "No question available")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .font(.title3)
                                    .foregroundColor(Color(hex: colors[currentQuestionIndex]).isDarkBackground() ? .white : .black)
                                
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
                            .background(Color(hex: colors[currentQuestionIndex]))
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
                                    .foregroundColor(.black)
                                Text("Add Card Manually")
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

                        Button(action: {
                            Task {
                                await addCardViaAI()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                                Text("Add Card via AI")
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
                        
                        HStack(spacing: 10) {
                            NavigationLink(destination: reviewView(questions: $questions, answers: $answers)) {
                                HStack {
                                    Spacer()
                                    Text("Review")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                    Spacer()
                                }
                                .padding()
                                .frame(height: 60)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: quizView(
                                deckTitle: set.title,
                                apiKey: openAIAPIKey,
                                questions: $questions,
                                answers: $answers)) {
                                HStack {
                                    Spacer()
                                    Text("Quiz")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                    Spacer()
                                }
                                .padding()
                                .frame(height: 60)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
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
            .sheet(isPresented: $showEditView) {
                editCurrentCardView(
                    question: $selectedQuestion,
                    answer: $selectedAnswer,
                    color: selectedColor,
                    deckID: set.id,
                    flashcardIndex: currentQuestionIndex,
                    onSave: { updatedQuestion, updatedAnswer, updatedColor in
                        updateFlashcard(question: updatedQuestion, answer: updatedAnswer, color: updatedColor)
                    },
                    onDelete: {
                        deleteFlashcard()
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    //ai card adder
    func addCardViaAI() async {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        
        let userID = user.uid
        let ref = Database.database().reference()
        let userSetRef = ref.child("users").child(userID).child("sets").child(set.id).child("words")
        
        // Fetch all existing terms and definitions to avoid duplicates
        let existingQuestions = questions
        let existingAnswers = answers
        
        do {
            let service = OpenAIService(apiKey: openAIAPIKey)
            
            // Generate a question and answer prompt based on the existing set
            let prompt = """
            Generate a new question and answer similar to these:
            \(existingQuestions.map { "- \($0)" }.joined(separator: "\n"))
            
            Make sure the question and answer are not duplicates.
            
            Respond in the following JSON format:
            {
                "question": "A unique question text",
                "answer": "A unique answer text"
            }
            """
            
            let response = try await service.sendPrompt(prompt: prompt, systemRole: "You are a helpful assistant generating unique flashcards.")
            
            guard let jsonData = response.data(using: .utf8),
                  let generatedCard = try? JSONDecoder().decode([String: String].self, from: jsonData),
                  let newQuestion = generatedCard["question"],
                  let newAnswer = generatedCard["answer"] else {
                print("Failed to decode OpenAI response.")
                return
            }
            
            // Ensure no duplicates
            guard !existingQuestions.contains(newQuestion), !existingAnswers.contains(newAnswer) else {
                print("Generated question/answer already exists. Try again.")
                return
            }
            
            // Create the new Word instance with the sequential id
            let nextIndex = questions.count
            let newWord = Word(id: "\(nextIndex)", term: newQuestion, definition: newAnswer, color: "#FFFFFF")
            
            // Add the Word to the database using its id
            userSetRef.child(newWord.id).setValue(newWord.toDictionary()) { error, _ in
                if let error = error {
                    print("Error adding card via AI: \(error.localizedDescription)")
                } else {
                    print("Card added via AI successfully.")
                    self.questions.append(newWord.term)
                    self.answers.append(newWord.definition)
                }
            }
        } catch {
            print("Error generating AI card: \(error.localizedDescription)")
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
                self.colors = []
                return
            }
            
            self.questions = wordsArray.compactMap { $0["term"] as? String }
            self.answers = wordsArray.compactMap { $0["definition"] as? String }
            self.colors = wordsArray.compactMap { $0["color"] as? String }
            
            if !self.questions.isEmpty {
                self.currentQuestionIndex = 0
            }
        }
    }
    
    // Function to update a flashcard
    func updateFlashcard(question: String, answer: String, color: String) {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        
        let userID = user.uid
        let ref = Database.database().reference()
        let flashcardRef = ref.child("users").child(userID).child("sets").child(set.id).child("words").child("\(currentQuestionIndex)")
        
        flashcardRef.updateChildValues(["term": question, "definition": answer, "color": color]) { error, _ in
            if let error = error {
                print("Error updating flashcard: \(error.localizedDescription)")
            } else {
                print("Flashcard updated successfully.")
                questions[currentQuestionIndex] = question
                answers[currentQuestionIndex] = answer
                colors[currentQuestionIndex] = color
            }
        }
    }

    // Function to delete a flashcard
    func deleteFlashcard() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        
        let userID = user.uid
        let ref = Database.database().reference()
        let flashcardRef = ref.child("users").child(userID).child("sets").child(set.id).child("words").child("\(currentQuestionIndex)")
        
        flashcardRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting flashcard: \(error.localizedDescription)")
            } else {
                print("Flashcard deleted successfully.")
                questions.remove(at: currentQuestionIndex)
                answers.remove(at: currentQuestionIndex)
                colors.remove(at: currentQuestionIndex)
                
                // Adjust the index to prevent out-of-bounds errors
                if currentQuestionIndex >= questions.count {
                    currentQuestionIndex = max(0, questions.count - 1)
                }
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
