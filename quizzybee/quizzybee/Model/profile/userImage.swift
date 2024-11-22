//
//  userImage.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI

struct userImage: View {
    let size: CGFloat
    
    var body: some View {
        Image("UserImage")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.black, lineWidth: 2)
            }
            .shadow(radius: 4)
    }
}

#Preview {
    userImage(size: 50)
}