//
//  UserImage.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/7.
//

import SwiftUI

struct userImage: View {
    var body: some View {
        Image("fakebee")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.black, lineWidth: 2)
            }
            .shadow(radius: 4)
    }
}

#Preview {
    userImage()
}
