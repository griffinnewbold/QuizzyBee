//
//  editCurrentCardView.swift
//  quizzybee
//
//  Created by ChiaPeng Wu on 11/24/24.
//

import SwiftUI
import Firebase

/// A view for editing or deleting an existing flashcard within a deck.
///
/// - Purpose:
///   - Allows the user to modify the question, answer, and background color of a flashcard.
///   - Provides options to save the changes or delete the flashcard.
struct editCurrentCardView: View {
    // MARK: - Properties
    @Binding var question: String // The question text of the flashcard.
    @Binding var answer: String   // The answer text of the flashcard.
    @Binding var color: String    // The background color of the flashcard as a hex string.
    @State private var showingColorPicker = false // Flag to show the color picker sheet.
    
    let deckID: String           // The ID of the deck containing the flashcard.
    let flashcardIndex: Int      // The index of the flashcard in the deck.
    let onSave: (String, String, String) -> Void // Closure to handle saving the updated flashcard.
    let onDelete: () -> Void     // Closure to handle deleting the flashcard.

    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the current view.

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all) // Background color
            
            VStack(spacing: 20) {
                // Header
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
                        onSave(question, answer, color)
                        dismiss() // Dismiss the view
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
                        onDelete()
                        dismiss() // Dismiss the view
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
                            get: { Color(hex: color) },
                            set: { newColor in color = newColor.toHex() ?? "#FFFFFF" }
                        ))
                        .padding()
                        
                        Button("Done") {
                            showingColorPicker = false // Close the color picker
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

// MARK: - Preview

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
