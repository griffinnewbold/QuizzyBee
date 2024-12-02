//
//  userImage.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI

/// A circular user profile image view with a border and shadow.
///
/// - Purpose:
///   - Displays a user profile image in a circular shape.
///   - Includes a black border and a subtle shadow for styling.
///
/// - Parameters:
///   - size: The diameter of the circular image.
///   - imageName: The name of the image asset to display.
struct userImage: View {
    /// The diameter of the circular image.
    let size: CGFloat
    
    /// The name of the image asset to display.
    let imageName: String
    
    /// The body of the `userImage` view.
    var body: some View {
        Image(imageName)
            .resizable() // Ensures the image can be resized
            .scaledToFit() // Maintains the image's aspect ratio
            .frame(width: size, height: size) // Sets the frame to the specified size
            .clipShape(Circle()) // Clips the image into a circular shape
            .overlay {
                // Black border around the circle
                Circle().stroke(.black, lineWidth: 2)
            }
            .shadow(radius: 4) // Adds a subtle shadow for depth
    }
}
