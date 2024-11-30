//
//  deckRow.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import SwiftUI

struct deckRow: View {
    let deckCard: Set
    let index: Int
    let showGeometry: Bool
    @Binding var defaultDeckFrame: CGRect
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        deckCardSummaryRow(deckCard: deckCard)
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            .overlay {
                if showGeometry {
                    GeometryReader { geometry -> Color in
                        DispatchQueue.main.async {
                            defaultDeckFrame = CGRect(
                                x: geometry.frame(in: .global).origin.x - 10,
                                y: UIScreen.main.bounds.height * 0.005,
                                width: geometry.size.width + 20,
                                height: 60
                            )
                        }
                        return Color.clear
                    }
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}
