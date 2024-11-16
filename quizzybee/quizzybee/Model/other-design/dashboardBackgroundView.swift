//
//  dashboardBackgroundView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/11.
//

import SwiftUI

struct dashboardBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: "7B7B7B").ignoresSafeArea()
                
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: 0, y: height * 0.4))
                    path.addLine(to: CGPoint(x: width * 0.7, y: 0))
                    path.closeSubpath()
                    
                    // Bottom-right triangle
                    path.move(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: width , y: height * 0.6))
                    path.addLine(to: CGPoint(x: width * 0.3 , y: height))
                    path.closeSubpath()
                }
                .fill(Color(hex: "FFD000"))
            }
        }
        .ignoresSafeArea()
    }
}
    
#Preview {
    dashboardBackgroundView()
}
