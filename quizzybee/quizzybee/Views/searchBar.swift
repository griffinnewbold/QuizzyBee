//
//  searchBar.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct searchBar: View {
    @Binding var searchText: String
    var placeholder: String
    var onSubmit: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $searchText)
                .submitLabel(.search)
                .onSubmit{onSubmit?()}
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    onSubmit?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

#Preview {
    searchBar(
        searchText: .constant(""),
        placeholder: "search deck...",
        onSubmit: {
            print("search submitted")
        }
    )
}
