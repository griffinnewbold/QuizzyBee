//
//  tips.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import SwiftUI

/// guide users to navigate into detailed deck view
struct tipsAnimation: View {
    let message: String
    let targetFrame: CGRect
    let onSkip: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            Path { path in
                path.addRect(CGRect(origin: .zero, size: UIScreen.main.bounds.size))
                path.addRoundedRect(in: targetFrame, cornerSize: CGSize(width: 8, height: 8))
            }
            .fill(style: FillStyle(eoFill: true))
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: onSkip) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
                .padding(.top, 8)
                
                Text(message)
                    .font(.subheadline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .position(x: targetFrame.midX, y: targetFrame.maxY + 50)
            
            Circle()
                .stroke(Color.yellow, lineWidth: 2)
                .frame(width: 30, height: 30)
                .position(x: targetFrame.midX, y: targetFrame.midY)
                .modifier(pulseAnimation())
        }
    }
}
