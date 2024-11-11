//
//  deckCardDetailView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct deckCardDetailView: View {
    let title: String
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        
        ZStack {
            Color(hex:"7B7B7B").ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {dismiss()}) {
                        Image(systemName: "chevron.left").foregroundColor(.white)
                        Text("Back to Decks").foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
                
                Text(title)
                    .font(.system(size: 25))
                    .bold()
                    .padding(.bottom, 30)
                
                ZStack {
                    // MARK: could be replaced by the flash card view
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 2)
                        .frame(height: 200)
                    
                    HStack {
                        Button {
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Statistics")
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        Button {
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 30)
                    // MARK: END
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                VStack(spacing: 0) {
                    Button("Start review") {
                        
                    }
                    .buttonStyle(WhiteButtonDesign())
                    .padding(.bottom, 30)
                    
                    
                    NavigationLink(destination: quizView()) {
                        Text("Quizes")
                    }
                        .buttonStyle(WhiteButtonDesign())
                        .padding(.bottom, 30)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Circle().fill(Color.white))
                            .shadow(radius: 2)
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    deckCardDetailView(title: "Intro to Java")
}
