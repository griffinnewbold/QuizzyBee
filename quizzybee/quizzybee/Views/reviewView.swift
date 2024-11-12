//
//  reviewView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/12.
//

import SwiftUI

struct reviewView: View {
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

//#Preview {
//    reviewView()
//}