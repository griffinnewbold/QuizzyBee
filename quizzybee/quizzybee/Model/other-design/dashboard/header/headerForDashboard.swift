//
//  headerForDashboard.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct headerForDashboard: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // for change in user image
    @State private var refreshID = UUID()
    
    var body: some View {
        HStack {
            NavigationLink(destination: userProfileView().environmentObject(authViewModel)) {
                userImage(size: 50,
                          imageName: authViewModel.user?.profileImage ?? "UserImage1")
            }
            .buttonStyle(PlainButtonStyle())
            .id(refreshID)
            
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
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("UserImageUpdated"),
                object: nil,
                queue: .main
            ) { _ in
                refreshID = UUID()
            }
        }
    }
}
