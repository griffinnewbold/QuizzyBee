//
//  UserImage.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/7.
//

import SwiftUI

struct UserImage: View {
    var body: some View {
        Image("fakebee")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.black, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    UserImage()
}
