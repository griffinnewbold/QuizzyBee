//
//  deckRow.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/28.
//

import SwiftUI

/// A row view for displaying a deck with support for delete actions and geometry tracking.
///
/// This row is part of a list and integrates features such as:
/// - Tapping to select a deck.
/// - Geometry tracking for onboarding animations.
/// - Swipe-to-delete functionality.
///
/// - Parameters:
///   - deckCard: The `Set` object representing the deck displayed in this row.
///   - index: The index of this row in the list.
///   - showGeometry: A flag indicating whether geometry should be tracked for this row.
///   - defaultDeckFrame: A binding to update the frame of the deck row for positioning onboarding animations.
///   - onTap: A closure to handle the tap action on the row.
///   - onDelete: A closure to handle the delete action for the deck.
struct deckRow: View {
    /// The deck represented by this row.
    let deckCard: Set

    /// The index of the deck in the list.
    let index: Int

    /// Whether to track the geometry of this row for onboarding purposes.
    let showGeometry: Bool

    /// The frame of the deck row, used for positioning onboarding animations.
    @Binding var defaultDeckFrame: CGRect
    
    @EnvironmentObject var authViewModel: AuthViewModel

    /// Closure to handle the tap action on the row.
    let onTap: () -> Void

    /// Closure to handle the delete action for the deck.
    let onDelete: () -> Void

    /// The body of the row, containing the deck information and actions.
    var body: some View {
        deckCardSummaryRow(deckCard: deckCard)
            .environmentObject(authViewModel)
            .contentShape(Rectangle()) // Makes the entire row tappable.
            .onTapGesture(perform: onTap) // Handles tap gestures.

            // Overlay to track the geometry of the row for onboarding animations.
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
            .padding(10) // Adds padding around the row.
            .background(Color.white) // Sets the row's background color.
            .cornerRadius(10) // Rounds the corners of the row.
            .shadow(radius: 3) // Adds a shadow to the row.

            // Swipe actions for deleting the deck.
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }

            // Adjusts list row appearance.
            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}
