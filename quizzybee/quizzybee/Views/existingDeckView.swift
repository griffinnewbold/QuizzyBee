//
//  existingDeckView.swift
//  quizzybee
//
//  Created by Chiapeng Wu on 2024/11/12.
//

import SwiftUI

struct existingDeckView: View {
    @State private var currentQuestionIndex = 0
    @State private var searchText = ""
    @State private var showAnswer = false
    
    let questions = [
        "What is the correct way to declare a variable of type integer in Java?",
        "Which access modifier makes a variable accessible only within its own class?"
    ]
    
    let answers = [
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
                    
                    HStack {
                        HStack {
                            TextField("Search keyword", text: $searchText)
                                .padding(.leading)
                            Spacer()
                            Button(action: {
                                //search button
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
                    
                    //link to newCardView
                    NavigationLink(destination: newCardView()) {
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
                    
                    //click Start Review will link to quizView
                    NavigationLink(destination: quizView()) {
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
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    existingDeckView()
}
