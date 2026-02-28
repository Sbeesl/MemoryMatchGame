//
//  Card.swift
//  MemoryMatchGame
//
//  Created by Skylar Beesley on 2/27/26.
//

import Foundation
import CoreGraphics

// Card is a struct that represents a single card in the memory matching game
struct Card: Identifiable {
    // Unique identifier so SwiftUI can track each card individually
    let id: UUID = UUID()
    
    // Tracks whether the card is currently showing its front (emoji) side
    var isFaceUp: Bool = false
    
    // Tracks whether this card has been successfully matched with its pair
    var isMatched: Bool = false
    
    // The emoji displayed on the front of the card
    let content: String
    
    // The card's position on screen, used for drag and deal animation
    var position: CGFloat = 0
}
