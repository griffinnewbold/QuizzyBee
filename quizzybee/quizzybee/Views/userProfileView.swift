//
//  userProfileView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct userProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // for updating images
    @State private var selectedImage = "UserImage1"
    @State private var refreshID = UUID()
    
    // MARK: user consent the use of AI
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
                
                userImage(size: 100,
                          imageName: authViewModel.user?.profileImage ?? "UserImage1").padding(.bottom, 20)
                    .id(refreshID)
                
                imageSelector(selectedImage: $selectedImage)
                    .onChange(of: selectedImage) { oldValue, newValue in  
                        authViewModel.updateUserProfileImage(imageName: newValue)
                    }
                
                Spacer()
                
                profileList().environmentObject(authViewModel)
                
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
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("UserImageUpdated"),
                object: nil,
                queue: .main
            ) { _ in
                refreshID = UUID()
            }
        }
    }
}

#Preview {
    return ZStack {
        Color(hex: "7B7B7B").ignoresSafeArea()
        
        userProfileView()
            .environmentObject(AuthViewModel())
    }
}
