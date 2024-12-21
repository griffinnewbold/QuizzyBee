//
//  imageSelector.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/26.
//

import SwiftUI

/// A horizontal image selector for choosing a profile image.
///
/// - Purpose:
///   - Allows users to select a profile image from a predefined list.
///   - Highlights the currently selected image.
///
/// - Features:
///   - Scrollable horizontal list of images.
///   - Yellow border to indicate the selected image.
///   - Updates the `selectedImage` binding when an image is tapped.
///
/// - Parameters:
///   - selectedImage: A binding to the currently selected image name.
struct imageSelector: View {
    /// The currently selected image name, bound to the parent view.
    @Binding var selectedImage: String
    
    /// List of available image names for selection.
    let availableImages = [
        "UserImage1", "UserImage2", "UserImage3", "UserImage4", "UserImage5",
        "UserImage6", "UserImage7", "UserImage8", "UserImage9", "UserImage10"
    ]
    
    /// The body of the image selector view.
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Display each available image
                ForEach(availableImages, id: \.self) { imageName in
                    userImage(size: 60, imageName: imageName)
                        .overlay {
                            // Highlight the selected image with a yellow border
                            if selectedImage == imageName {
                                Circle()
                                    .stroke(Color.yellow, lineWidth: 3)
                                    .padding(-4)
                            }
                        }
                        .onTapGesture {
                            selectedImage = imageName // Update the selected image
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(hex: "2C2C2C")) // Dark gray background
            .cornerRadius(12)
        }
    }
}
