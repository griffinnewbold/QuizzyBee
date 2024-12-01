//
//  editCurrentCardView.swift
//  quizzybee
//
//  Created by ChiaPeng Wu on 11/24/24.
//

import SwiftUI
import Firebase

struct editCurrentCardView: View {
    @Binding var question: String
    @Binding var answer: String
    @Binding var color: String
    @State private var showingColorPicker = false
    let deckID: String
    let flashcardIndex: Int
    let onSave: (String, String, String) -> Void
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
                        .background(Color(hex: color))
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
                        .background(Color(hex: color))
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
                    // Change Card Color Button
                    Button(action: {
                        // Toggle the visibility of the color picker
                        showingColorPicker.toggle()
                    }) {
                        Text("Change Card Color")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    .padding(.bottom, 10)
                    // Save Button
                    Button(action: {
                        onSave(question, answer, color) // Save action
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
                .sheet(isPresented: $showingColorPicker) {
                    // Color Picker Sheet
                    VStack {
                        Text("Pick a Color for the Card Background")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                        
                        ColorPicker("Select Color", selection: Binding(
                            get: {
                                Color(hex: color)
                            },
                            set: { newColor in
                                color = newColor.toHex() ?? "#FFFFFF"
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
            }
        }
    }
}

#Preview {
    editCurrentCardView(
        question: .constant("Sample Question"),
        answer: .constant("Sample Answer"),
        color: .constant("#FFFFFF"),
        deckID: "sampleDeckID",
        flashcardIndex: 0,
        onSave: { updatedQuestion, updatedAnswer, updatedColor in
            print("Saved question: \(updatedQuestion), answer: \(updatedAnswer), color: \(updatedColor)")
        },
        onDelete: {
            print("Flashcard deleted")
        }
    )
}
