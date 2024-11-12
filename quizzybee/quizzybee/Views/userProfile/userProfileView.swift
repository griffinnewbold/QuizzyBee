//
//  userProfileView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct userProfileView: View {
    // user consent the use of AI
    @AppStorage("allow AI") var allowAI = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex:"7B7B7B").ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    Button(action: {dismiss()}) {
                        Image(systemName: "chevron.left").foregroundColor(.white)
                        Text("Back to Dashboard").foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
                
                userImage(size: 100).padding(.bottom, 50)
                
                Spacer()
                
                profileList()
                
                HStack {
                    Toggle(isOn: $allowAI) {
                        Text("I consent to use gen AI to generate quizzes for my study.")
                    }
                    .tint(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .padding(.bottom, 200)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    userProfileView()
}