//
//  welcome.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import SwiftUI

struct welcome: View {
    @EnvironmentObject var tourGuide: onboardingModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    if let userID = authViewModel.user?.userID {
                        tourGuide.skipTour(userID: userID)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
            .padding(.top, 8)
            
            Text(onboardingModel.TourStep.welcome.message)
                .font(.title3)
                .multilineTextAlignment(.center)
            
            Button("Show me around") {
                if let userID = authViewModel.user?.userID {
                    tourGuide.nextStep(userID: userID)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .padding(.vertical, 6)
            .background(Color(hex: "FFD000").opacity(0.7))
            .foregroundColor(.black)
            .cornerRadius(8)
            .padding(.bottom, 10)
        }
        .background(Color.white.opacity(0.7))
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .padding(.horizontal)
    }
}
