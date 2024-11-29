//
//  highlightOverlay.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/29.
//

import SwiftUI

struct highlightOverlay: View {
    let frame: CGRect

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        Rectangle()
                            .path(in: CGRect(origin: .zero, size: geometry.size))
                            .fill(Color.black.opacity(0.6))
                            .background(
                                Color.clear
                                    .frame(width: frame.width, height: frame.height)
                                    .position(x: frame.midX, y: frame.midY)
                            )
                            .blendMode(.destinationOut)
                    )
                    .compositingGroup()
                
                Rectangle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: frame.width, height: frame.height)
                    .position(x: frame.midX, y: frame.midY)
            }
        }
        .ignoresSafeArea()
    }
}
