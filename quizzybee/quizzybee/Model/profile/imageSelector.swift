//
//  imageSelector.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/26.
//

import SwiftUI

struct imageSelector: View {
    @Binding var selectedImage: String
    
    // prepare the list of all assets
    let availableImages = ["UserImage1", "UserImage2", "UserImage3", "UserImage4", "UserImage5", "UserImage6", "UserImage7", "UserImage8", "UserImage9", "UserImage10"]
                           
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(availableImages, id: \.self) { imageName in
                    userImage(size: 50, imageName: imageName)
                        .onTapGesture {
                            selectedImage = imageName
                        }
                        .overlay {
                            if selectedImage == imageName {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 3)
                            }
                        }
                }
            }
            .padding()
        }
    }
}
