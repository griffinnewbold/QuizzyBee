//
//  existingDeckView.swift
//  quizzybee
//
//  Created by Chiapeng Wu on 2024/11/12.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct existingDeckView: View {
    let set: Set
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var tourGuide: onboardingModel
    @EnvironmentObject var envLoader: EnvironmentLoader
    
    @State private var currentQuestionIndex = 0
    @State private var searchText = ""
    @State private var showAnswer = false
    @State private var questions: [String] = []
    @State private var answers: [String] = []
    @State private var colors: [String] = []
    @State private var isLoading = true
    @State private var selectedVoice: String = "Default"
    
    // Text-to-speech
    @StateObject private var speech = textToSpeech()
    @State private var isPlaying = false
    
    @State private var showEditView = false
    @State private var selectedQuestion: String = ""
    @State private var selectedAnswer: String = ""
    @State private var selectedColor: String = ""
    
    @State private var deckTitle: String
    @State private var flashcardIDs: [String] = []
    
    init(set: Set) {
        self.set = set
        self._deckTitle = State(initialValue: set.title)
    }
    
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
                        Text(deckTitle)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                        NavigationLink(destination: EditDeckTitleView(deckID: set.id, title: $deckTitle).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
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
                        ProgressView("Loading...")
                            .scaleEffect(1.5)
                            .padding()
                    } else if questions.isEmpty {
                        VStack {
                            Text("No flashcards available.")
                                .foregroundColor(.gray)
                                .font(.headline)
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
                            
                            ZStack(alignment: .topTrailing) {
                                Text(showAnswer ? answers[safe: currentQuestionIndex] ?? "No answer available" : questions[safe: currentQuestionIndex] ?? "No question available")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.5)
                                    .font(.title3)
                                    .foregroundColor(Color(hex: colors[safe: currentQuestionIndex] ?? "#FFFFFF").isDarkBackground() ? .white : .black)
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .background(Color(hex: colors[safe: currentQuestionIndex] ?? "#FFFFFF"))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        showAnswer.toggle()
                                        isPlaying = false
                                        speech.stop()
                                    }
                                    .onChange(of: currentQuestionIndex) { _, _ in
                                        isPlaying = false
                                        speech.stop()
                                    }
                                
                                // Speaker and Pencil Icons
                                HStack() {
                                    // Speaker Icon
                                    Button(action: {
                                        handleTextToSpeech()
                                    }) {
                                        Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                                            .foregroundColor(.black)
                                            .padding(8)
                                            .background(Color.gray.opacity(0.2))
                                            .clipShape(Circle())
                                    }
                                    
                                    // Pencil Icon
                                    Button(action: {
                                        if let question = questions[safe: currentQuestionIndex],
                                           let answer = answers[safe: currentQuestionIndex],
                                           let color = colors[safe: currentQuestionIndex] {
                                            selectedQuestion = question
                                            selectedAnswer = answer
                                            selectedColor = color
                                            showEditView = true
                                        }
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.black)
                                            .padding(8)
                                            .background(Color.gray.opacity(0.2))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
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
                            NavigationLink(destination: quizView(
                                deckTitle: set.title,
                                apiKey: envLoader.get("OPEN_AI_SECRETS")!,
                                questions: $questions,
                                answers: $answers)
                                .tint(.black)
                            ) {
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
                
                if let currentStep = onboardingModel.TourStep.allCases[safe: tourGuide.currentStep],
                   (2...7).contains(tourGuide.currentStep), let userID = authViewModel.user?.userID {
                    tipView(
                        currentStep: currentStep,
                        nextStep: { tourGuide.nextStep(userID: userID) },
                        skipTour: { tourGuide.skipTour(userID: userID) }
                    )
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                isLoading = true
                fetchFlashcards(forSet: set)
                loadUserVoiceModel()
                fetchDeckTitle()
            }
            .sheet(isPresented: $showEditView) {
                editCurrentCardView(
                    question: $selectedQuestion,
                    answer: $selectedAnswer,
                    color: $selectedColor,
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
            let service = OpenAIService(apiKey: envLoader.get("OPEN_AI_SECRETS")!)
            
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
            Task {
                do {
                    try await userSetRef.child(newWord.id).setValue(newWord.toDictionary())
                    print("Card added via AI successfully.")
                    self.questions.append(newWord.term)
                    self.answers.append(newWord.definition)
                } catch {
                    print("Error adding card via AI: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error generating AI card: \(error.localizedDescription)")
        }
    }
    
    func fetchDeckTitle() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        
        let userID = user.uid
        let ref = Database.database().reference()
        let deckTitleRef = ref.child("users").child(userID).child("sets").child(set.id).child("title")
        
        deckTitleRef.observe(.value) { snapshot in
            if let updatedTitle = snapshot.value as? String {
                self.deckTitle = updatedTitle
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
        
        userSetRef.observe(.value) { snapshot in
            defer { self.isLoading = false }
            
            guard let wordsArray = snapshot.value as? [[String: Any]] else {
                print("No flashcards found or invalid format.")
                self.questions = []
                self.answers = []
                self.colors = []
                self.flashcardIDs = []
                return
            }
            
            self.questions = wordsArray.compactMap { $0["term"] as? String }
            self.answers = wordsArray.compactMap { $0["definition"] as? String }
            self.colors = wordsArray.compactMap { $0["color"] as? String }
            self.flashcardIDs = wordsArray.compactMap { $0["id"] as? String }
            
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
        
        guard currentQuestionIndex < questions.count else {
            print("Index out of bounds.")
            return
        }
        
        let userID = user.uid
        let ref = Database.database().reference()
        let userSetRef = ref.child("users").child(userID).child("sets").child(set.id).child("words")
        
        // Remove the specific card locally
        _ = flashcardIDs[currentQuestionIndex]
        questions.remove(at: currentQuestionIndex)
        answers.remove(at: currentQuestionIndex)
        colors.remove(at: currentQuestionIndex)
        flashcardIDs.remove(at: currentQuestionIndex)
        
        // Reorganize remaining flashcards
        var updatedFlashcards: [[String: Any]] = []
        for (index, question) in questions.enumerated() {
            let updatedCard: [String: Any] = [
                "id": "\(index)",
                "term": question,
                "definition": answers[index],
                "color": colors[index]
            ]
            updatedFlashcards.append(updatedCard)
        }
        
        // Write the updated flashcards back to Firebase
        userSetRef.setValue(updatedFlashcards) { error, _ in
            if let error = error {
                print("Error updating flashcards in Firebase: \(error.localizedDescription)")
            } else {
                print("Flashcards successfully updated in Firebase.")
            }
        }
        
        // Adjust currentQuestionIndex to prevent out-of-bounds errors
        if currentQuestionIndex >= questions.count {
            currentQuestionIndex = max(0, questions.count - 1)
        }
    }
    
    private func loadUserVoiceModel() {
        authViewModel.fetchUserVoiceModel { voiceModel in
            if let model = voiceModel {
                selectedVoice = model
            } else {
                selectedVoice = "Default"
            }
        }
    }
    
    // MARK: Handle Text-to-Speech
    private func handleTextToSpeech() {
        let textToSpeak = showAnswer
        ? (answers[safe: currentQuestionIndex] ?? "")
        : (questions[safe: currentQuestionIndex] ?? "")
        
        if selectedVoice == "Default" {
            isPlaying.toggle()
            if isPlaying {
                speech.speak(textToSpeak)
            } else {
                speech.stop()
            }
        } else {
            isPlaying.toggle()
            if isPlaying {
                Task {
                    do {
                        let audioURL = try await ElevenLabsAPI.synthesizeSpeech(
                            voiceId: selectedVoice,
                            text: textToSpeak
                        )
                        speech.playAudio(from: audioURL)
                    } catch {
                        print("Error using ElevenLabsAPI: \(error.localizedDescription)")
                        isPlaying = false
                    }
                }
            } else {
                speech.stop()
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
