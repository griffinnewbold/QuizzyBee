//
//  CustomTextField.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/9/24.
//

import SwiftUI

/// A customizable text field with a clean design and user-friendly features.
///
/// - Purpose:
///   - Provides a reusable text field component with padding, background styling, and accessibility features.
///   - Designed for use across the app where input fields are needed.
///
/// - Features:
///   - Placeholder text for guidance.
///   - Rounded corners and shadow for visual styling.
///   - Disables autocorrection and autocapitalization for better user experience.
///
/// - Parameters:
///   - placeholder: A string that appears when the text field is empty.
///   - text: A binding to the text entered in the field.
struct CustomTextField: View {
    /// The placeholder text displayed when the text field is empty.
    var placeholder: String
    
    /// The text entered by the user, bound to the parent view.
    @Binding var text: String

    /// The body of the `CustomTextField` view.
    var body: some View {
        TextField(placeholder, text: $text)
            .padding() // Adds padding inside the text field
            .background(Color.white) // White background for the text field
            .cornerRadius(10) // Rounded corners for a smoother look
            .shadow(radius: 5) // Subtle shadow for depth
            .autocapitalization(.none) // Disables automatic capitalization
            .autocorrectionDisabled() // Disables autocorrection
    }
}
