//
//  WhiteButtonDesign.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import Foundation
import SwiftUI

struct WhiteButtonDesign: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16))
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
