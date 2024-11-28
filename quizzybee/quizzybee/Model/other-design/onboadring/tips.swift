//
//  tips.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import SwiftUI

struct tips: View {
    let message: String
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .padding()
                .background(Color.yellow.opacity(0.7))
                .cornerRadius(8)
            
            Button("Next", action: onNext)
                .padding(.horizontal)
        }
    }
}
