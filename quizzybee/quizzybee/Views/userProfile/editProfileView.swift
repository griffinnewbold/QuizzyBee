//
//  editProfileView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct editProfileView: View {
    @Binding var value: String
    let label: String
    let isSecure: Bool
    @Environment(\.dismiss) var dismiss
    @State private var tempValue: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isSecure {
                    SecureField("Enter new \(label.lowercased())", text: $tempValue)
                } else {
                    TextField("Enter new \(label.lowercased())", text: $tempValue)
                }
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .navigationTitle("Edit \(label)")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    value = tempValue
                    dismiss()
                }
                    .disabled(tempValue.isEmpty)
            )
        }
        .onAppear {
            tempValue = value
        }
    }
}
