//
//  headerForDashboard.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct headerForDashboard: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack {
            NavigationLink(destination: userProfileView().environmentObject(authViewModel)) {
                userImage(size: 50)
            }
            .buttonStyle(PlainButtonStyle())
            
            if let userName = authViewModel.user?.fullName, !userName.isEmpty {
                Text("Hello, \(userName)!")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .bold()
            } else {
                Text("Hello, newbee!")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .bold()
            }
            
            gearShape()
        }
    }
}

#Preview {
    headerForDashboard().environmentObject(AuthViewModel())
}
