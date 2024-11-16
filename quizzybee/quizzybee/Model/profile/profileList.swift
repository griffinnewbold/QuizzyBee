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
        VStack(spacing: 16) {
            profileRow(label: "Full Name", value: Binding(
                get: { authViewModel.user?.fullName ?? "" },
                set: { newValue in
                    if var updatedUser = authViewModel.user {
                        updatedUser.fullName = newValue
                        authViewModel.updateUserProfile(updatedUser)
                    }
                }
            ))
            
            // MARK: Email is read only
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .foregroundColor(.gray.opacity(0.8))
                        .font(.system(size: 14))
                    
                    Text(authViewModel.user?.email ?? "")
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            profileRow(label: "Password", value: $currentPassword, isSecure: true)
            
            Spacer()
        }
        .padding(.top)
        .background(Color(hex: "7B7B7B").ignoresSafeArea())
    }
}

#Preview {
    let mockAuthViewModel = AuthViewModel()
        mockAuthViewModel.user = User(
            userID: "preview-id",
            fullName: "Preview User",
            email: "preview@example.com",
            createdAt: Date().timeIntervalSince1970,
            sets: [:]
        )
        
    return profileList().environmentObject(mockAuthViewModel)
}
