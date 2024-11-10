//
//  DeckView.swift
//  quizzybee
//
//  Created by ChiaPeng Wu on 11/9/24.
//

import SwiftUI

struct DeckView: View {
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {  // Added spacing for equal spacing between elements
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    Text("Intro to Java")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.horizontal)
                
                HStack {
                    HStack {
                        TextField("Search keyword", text: .constant(""))
                            .padding(.leading)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                VStack {
                    Text("What is the correct way to declare a variable of type integer in Java?")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                HStack(spacing: 8) {
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(index == 0 ? Color.black : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Button(action: {
                    // Add button
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 60)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    // Start review button
                }) {
                    HStack {
                        Spacer()
                        Text("Start Review")
                            .foregroundColor(.black)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}










