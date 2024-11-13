//
//  profileList.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct profileList: View {
    @State private var fullName = "New Bee"
    @State private var email = "nbee@123"
    @State private var password = "******"
    
    var body: some View {
        VStack(spacing: 16) {
            profileRow(label: "Full Name", value: $fullName)
            profileRow(label: "Email", value: $email)
            profileRow(label: "Password", value: $password, isSecure: true)
            
            Spacer()
        }
        .padding(.top)
        .background(Color(hex: "7B7B7B").ignoresSafeArea())
    }
}

#Preview {
    profileList()
}
