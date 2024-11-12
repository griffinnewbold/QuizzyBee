//
//  CustomTextField.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/9/24.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text) 
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .autocapitalization(.none)
            .autocorrectionDisabled()
    }
}
