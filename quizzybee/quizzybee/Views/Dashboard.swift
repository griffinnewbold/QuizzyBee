//
//  Dashboard.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/7.
//

import SwiftUI

struct Dashboard: View {
    
    var body: some View {
        ZStack {
            Color(hex:"7B7B7B").ignoresSafeArea()
            HStack {
                UserImage()
                    
                Spacer()
                
                Text("Hello, newbee!")
                    .font(.title)
                
                Text("Now I'm here.")
            }
            
        }
    }
}

#Preview {
    Dashboard()
}
