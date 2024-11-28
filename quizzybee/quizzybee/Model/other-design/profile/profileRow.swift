//
//  profileRow.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct profileRow: View {
    let label: String
    @Binding var value: String
    var isSecure: Bool = false
    @State private var isEditing = false

    var body: some View {
        HStack {
            // Label and Value
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .foregroundColor(.yellow)
                    .font(.system(size: 14, weight: .bold))
                
                Text(isSecure ? String(repeating: "•", count: value.count) : value)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            Spacer()
            
            // Edit Button
            Button(action: {
                isEditing = true
            }) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.yellow)
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "2C2C2C")) // Dark gray background
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow, lineWidth: 1) // Yellow border
                )
        )
        .padding(.horizontal, 16)
        .sheet(isPresented: $isEditing) {
            editProfile(value: $value, label: label, isSecure: isSecure)
        }
    }
}
