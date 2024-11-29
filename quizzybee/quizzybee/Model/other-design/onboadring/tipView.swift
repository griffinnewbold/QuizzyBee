//
//  tipView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/29.
//

import SwiftUI

struct tipView: View {
    let currentStep: onboardingModel.TourStep
    let nextStep: () -> Void
    let skipTour: () -> Void
    
    var tipOnTop: Bool {
        let screenHeight = UIScreen.main.bounds.height
        return currentStep.highlightFrame.midY > screenHeight/2
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            highlightOverlay(frame: currentStep.highlightFrame)
            
            VStack {
                if tipOnTop {
                    VStack(spacing: 16) {
                        tipContent
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding()
                    
                    Spacer()
                } else {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        tipContent
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding()
                }
            }
        }
    }
    
    private var tipContent: some View {
        VStack(spacing: 16) {
            Text(currentStep.message)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack {
                Button(action: skipTour) {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                
                Button(action: nextStep) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
    }
}
