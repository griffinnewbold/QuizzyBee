//
//  pulseAnimation.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import Foundation
import SwiftUI

struct pulseAnimation: ViewModifier {
    @State private var scale: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(2 - scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                    scale = 2
                }
            }
    }
}
