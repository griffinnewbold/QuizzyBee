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
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .foregroundColor(.gray.opacity(0.8))
                    .font(.system(size: 14))
                
                if isSecure {
                    Text(String(repeating: "•", count: value.count))
                        .font(.system(size: 16))
                } else {
                    Text(value)
                        .font(.system(size: 16))
                }
            }
            
            Spacer()
            
            Button(action: {
                isEditing = true
            }) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal)
        .sheet(isPresented: $isEditing) {
            editProfile(value: $value, label: label, isSecure: isSecure)
        }
    }
}

#Preview {
    // constant, no-editable binding
    profileRow(label: "Full Name", value: .constant("New Bee"))
}
