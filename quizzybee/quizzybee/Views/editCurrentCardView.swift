//
//  editCurrentCardView.swift
//  quizzybee
//
//  Created by Justin Wu on 11/24/24.
//

import SwiftUI
import Firebase

struct editCurrentCardView: View {
    @Binding var question: String
    @Binding var answer: String
    let deckID: String
    let flashcardIndex: Int
    let onSave: (String, String) -> Void
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {

                Text("Edit Current Flashcard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)

                // Question Input Field
                VStack(alignment: .leading) {
                    Text("Question:")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 5)
                    TextEditor(text: $question)
                        .padding()
                        .frame(height: 160)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                // Answer Input Field
                VStack(alignment: .leading) {
                    Text("Answer:")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 5)
                    TextEditor(text: $answer)
                        .padding()
                        .frame(height: 160)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                Spacer()

                VStack(spacing: 20) {
                    // Save Button
                    Button(action: {
                        onSave(question, answer) // Save action
                        dismiss() // Return to existingDeckView
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }

                    // Delete Button
                    Button(action: {
                        onDelete() // Delete action
                        dismiss() // Return to existingDeckView
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    editCurrentCardView(
        question: .constant("Sample Question"),
        answer: .constant("Sample Answer"),
        deckID: "sampleDeckID",
        flashcardIndex: 0,
        onSave: { updatedQuestion, updatedAnswer in
            print("Saved question: \(updatedQuestion), answer: \(updatedAnswer)")
        },
        onDelete: {
            print("Flashcard deleted")
        }
    )
}
