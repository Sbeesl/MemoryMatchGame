//
//  CardGameViewModel.swift
//  MemoryMatchGame
//
//  Created by Skylar Beesley on 2/27/26.
//

import Foundation
import Combine
import SwiftUI

// The ViewModel managers all game state and logic, and publishes changes to the UI
class CardGameViewModel: ObservableObject {
    
    // Published properties automatically update the UI when they change
    @Published var cards: [Card] = []
    @Published var score: Int = 0
    @Published var moves: Int = 0
    @Published var gameOver: Bool = false
    
    // Tracks the first card selected, waiting for a second card to compare
    private var firstSelectedCard: Card? = nil
    
    // The set of emojis used to create card pairs
    private let emojis = ["🎯", "🎲", "🧩", "🎁", "🎈", "🎉"]
    
    // Start a new game when the ViewModel is first created
    init() {
        startNewGame()
    }
    
    // Set up a fresh game by creating paired cards and resetting all states
    func startNewGame() {
        // Create two of each emoji to make pairs, then shuffle their order
        let paired = (emojis + emojis).map { Card(content: $0) }
        cards = paired.shuffled()
        score = 0
        moves = 0
        gameOver = false
        firstSelectedCard = nil
        
    }
    
    // Randomly reorders the cards without resetting the score or moves
    func shuffleCards() {
        cards.shuffle()
    }
    
    // Handles all logic when a player selects a card
    func selectCard(_ selectedCard: Card) {
        // Ignore taps on matched cards or already face up cards
        guard let index = cards.firstIndex(where: { $0.id == selectedCard.id }),
              !cards[index].isMatched,
              !cards[index].isFaceUp else {return }
        
        if let first = firstSelectedCard {
            // Second card selected - flip it up and check for a match
            moves += 1
            cards[index].isFaceUp = true
            
            if cards[index].content == first.content {
                // Cards match - mark both as matched and award points
                cards[index].isMatched = true
                if let firstIndex = cards.firstIndex(where: { $0.id == first.id }) {
                    cards[firstIndex].isMatched = true
                }
                score += 2
                
                // Check if all pairs have been matched to end the game
                if cards.allSatisfy({ $0.isMatched}) {
                    gameOver = true
                }
            } else {
                // Cards don't match - deduct a point and flip both back after a delay
                score = max(0, score - 1)
                let selectedId = cards[index].id
                let firstId = first.id
                
                // Wait 1 second so the player can see both cards before flipping back
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if let i = self.cards.firstIndex(where: { $0.id == selectedId }) {
                        self.cards[i].isFaceUp = false
                    }
                    if let i = self.cards.firstIndex(where: { $0.id == firstId }) {
                        self.cards[i].isFaceUp = false
                    }
                }
            }
            
            // Reset first selected card so the next tap starts a new pair
            firstSelectedCard = nil
        } else {
            // First card selected - flip all unmatched cards face down first
            for i in cards.indices {
                if !cards[i].isMatched {
                    cards[i].isFaceUp = false
                }
            }
            cards[index].isFaceUp = true
            firstSelectedCard = cards[index]
        }
    }
}
