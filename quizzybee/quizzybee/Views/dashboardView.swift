//
//  dashboardView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import SwiftUI

struct dashboardView: View {
    var body: some View {
        ZStack {
            Color(hex:"7B7B7B").ignoresSafeArea()
            HStack {
                userImage()
                    
                Text("Hello, newbee!")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .bold()
                    
                    
            }
                
        }
    }
}

#Preview {
    dashboardView()
}
