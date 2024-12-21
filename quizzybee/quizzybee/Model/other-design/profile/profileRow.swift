//
//  profileRow.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A row component for displaying and editing a profile field.
///
/// - Purpose:
///   - Displays a profile field with a label and value.
///   - Allows users to edit the value using an edit button that opens an edit sheet.
///
/// - Features:
///   - Supports secure display for sensitive fields (e.g., password).
///   - Customizable styling to match the app's design.
///   - Integrates with `editProfile` to handle editing functionality.
///
/// - Parameters:
///   - label: The label for the field (e.g., "Password", "Full Name").
///   - value: A binding to the current value of the field.
///   - isSecure: A boolean indicating whether the field should be displayed securely (default is `false`).
struct profileRow: View {
    /// The label for the field (e.g., "Password", "Full Name").
    let label: String
    
    /// The current value of the field, bound to the parent view.
    @Binding var value: String
    
    /// Indicates whether the field should be displayed securely (e.g., for passwords).
    var isSecure: Bool = false

    /// Indicates whether the user is editing the field.
    @State private var isEditing = false

    /// The body of the profile row view.
    var body: some View {
        HStack {
            // Label and Value
            VStack(alignment: .leading, spacing: 4) {
                // Field label
                Text(label)
                    .foregroundColor(.yellow)
                    .font(.system(size: 14, weight: .bold))
                
                // Field value (secure if `isSecure` is true)
                Text(isSecure ? String(repeating: "•", count: value.count) : value)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            Spacer()
            
            // Edit Button
            Button(action: {
                isEditing = true // Triggers the edit sheet
            }) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.yellow)
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "2C2C2C")) // Dark gray background
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow, lineWidth: 1) // Yellow border
                )
        )
        .padding(.horizontal, 16)
        .sheet(isPresented: $isEditing) {
            // Opens the edit sheet with the `editProfile` view
            editProfile(value: $value, label: label, isSecure: isSecure)
        }
    }
}
