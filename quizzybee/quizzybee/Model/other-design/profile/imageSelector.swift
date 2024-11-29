//
//  imageSelector.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/26.
//

import SwiftUI

struct imageSelector: View {
    @Binding var selectedImage: String
    
    // List of all available images
    let availableImages = ["UserImage1", "UserImage2", "UserImage3", "UserImage4", "UserImage5", "UserImage6", "UserImage7", "UserImage8", "UserImage9", "UserImage10"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(availableImages, id: \.self) { imageName in
                    userImage(size: 60, imageName: imageName)
                        .overlay {
                            if selectedImage == imageName {
                                Circle()
                                    .stroke(Color.yellow, lineWidth: 3) // Yellow highlight for selected image
                                    .padding(-4)
                            }
                        }
                        .onTapGesture {
                            selectedImage = imageName
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
