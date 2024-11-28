//
//  profileList.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct profileList: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var currentPassword: String = "******"
    
    var body: some View {
        VStack(spacing: 20) {
        
            profileRow(
                label: "Full Name",
                value: Binding(
                    get: { authViewModel.user?.fullName ?? "" },
                    set: { newValue in
                        if var updatedUser = authViewModel.user {
                            updatedUser.fullName = newValue
                            authViewModel.updateUserProfile(updatedUser)
                        }
                    }
                )
            )
            .background(Color(hex: "2C2C2C"))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .foregroundColor(.yellow)
                        .font(.system(size: 14, weight: .bold))
                    
                    Text(authViewModel.user?.email ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "2C2C2C"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 16)
            
            profileRow(label: "Password", value: $currentPassword, isSecure: true)
                .background(Color(hex: "2C2C2C"))
                .cornerRadius(12)
                .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .background(Color(hex: "2C2C2C").ignoresSafeArea()) // Matches main view background
    }
}
