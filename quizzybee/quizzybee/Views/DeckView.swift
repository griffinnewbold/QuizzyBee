//
//  DeckView.swift
//  quizzybee
//
//  Created by ChiaPeng Wu on 11/9/24.
//

import SwiftUI

struct DeckView: View {
    @State private var currentQuestionIndex = 0
    @State private var searchText = ""
    @State private var showAnswer = false
    @State private var questions = [
        "What is the correct way to declare a variable of type integer in Java?",
        "Which access modifier makes a variable accessible only within its own class?"
    ]
    @State private var answers = [
        "Integer x = 10;",
        "private"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    HStack {
                        Button(action: {
                            //return to Dashboard button?
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                        Text("Intro to Java")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            //setting button
                        }) {
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    //search keyword search bar
                    HStack {
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
                    }
                    
                    //flashcards
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
                            Text(showAnswer ? answers[currentQuestionIndex] : questions[currentQuestionIndex])
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
                    
                    //flashcards page
                    HStack(spacing: 8) {
                        ForEach(questions.indices, id: \..self) { index in
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
                    
                    //click plus will link to addNewCardView
                    NavigationLink(destination: AddNewCardView(questions: $questions, answers: $answers)) {
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
                    
                    //click Start Review will link to StartReview
                    NavigationLink(destination: StartReviewView(questions: $questions, answers: $answers)) {
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
                    
                    //click Start Review will link to quizView
                    NavigationLink(destination: quizView()) {
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
        }
    }
}

//AddNewCardView
struct AddNewCardView: View {
    @Binding var questions: [String]
    @Binding var answers: [String]
    @State private var newQuestion = ""
    @State private var newAnswer = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldNavigateToRateNewCard = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Add New Flashcard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 20) {
                    TextField("Type or hand write your question...", text: $newQuestion)
                        .padding()
                        .frame(width: 300, height: 280)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Type or hand write your answer...", text: $newAnswer)
                        .padding()
                        .frame(width: 300, height: 280)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    if !newQuestion.isEmpty && !newAnswer.isEmpty {
                        questions.append(newQuestion)
                        answers.append(newAnswer)
                        shouldNavigateToRateNewCard = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Save to Deck")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 60)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.yellow.edgesIgnoringSafeArea(.all))
            .navigationDestination(isPresented: $shouldNavigateToRateNewCard) {
                RateNewCardView(question: newQuestion, answer: newAnswer)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

//RateNewCardView
struct RateNewCardView: View {
    @Environment(\.presentationMode) var presentationMode
    let question: String
    let answer: String
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Rate New Flashcard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                ZStack {
                    if isFlipped {
                        Text(answer)
                            .font(.title)
                            .frame(width: 300, height: 200)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    isFlipped.toggle()
                                }
                            }
                    } else {
                        Text(question)
                            .font(.title)
                            .frame(width: 300, height: 200)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    isFlipped.toggle()
                                }
                            }
                    }
                }
                
                Text("How hard was this question?")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 20) {
                    Button(action: {
                        // Handle Easy button action
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Easy")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Handle Medium button action
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Medium")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100, height: 50)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Handle Hard button action
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Hard")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

//StartReviewView
struct StartReviewView: View {
    @Binding var questions: [String]
    @Binding var answers: [String]
    @State private var currentQuestionIndex = 0
    @State private var showAnswer = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
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
                    Text(showAnswer ? answers[currentQuestionIndex] : questions[currentQuestionIndex])
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
            
            HStack(spacing: 8) {
                ForEach(questions.indices, id: \..self) { index in
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
            
            Spacer()
        }
        .padding(.vertical)
        .background(Color.yellow.edgesIgnoringSafeArea(.all))
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
