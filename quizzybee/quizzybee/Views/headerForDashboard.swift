//
//  headerForDashboard.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct headerForDashboard: View {
    var body: some View {
        HStack {
            userImage()
                
            Text("Hello, newbee!")
                .font(.largeTitle)
                .foregroundColor(Color(hex: "FFFFFF"))
                .bold()
                
            gearShape()
                
        }
    }
}

#Preview {
    headerForDashboard()
}
