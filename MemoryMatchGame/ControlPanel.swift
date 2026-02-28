//
//  ControlPanel.swift
//  MemoryMatchGame
//
//  Created by Skylar Beesley on 2/27/26.
//

import SwiftUI

struct ControlPanel: View {
    // Observes the view model so the panel updates when score or moves change
    @ObservedObject var viewModel: CardGameViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            // Display the current score and move count side by side
            HStack {
                Text("Score: \(viewModel.score)")
                    .font(.headline)
                Spacer()
                Text("Moves: \(viewModel.moves)")
                    .font(.headline)
            }
            
            // Buttons for starting a new game or shuffling the current cards
            HStack(spacing: 20) {
                // Resets the entire game including score and moves
                Button("New Game") {
                    withAnimation(.spring()) {
                        viewModel.startNewGame()
                    }
                }
                Button("Shuffle") {
                    withAnimation(.spring()) {
                        viewModel.shuffleCards()
                    }
                }
            }
            
            // Show a green game over message when all pairs are matched
            if viewModel.gameOver {
                Text("Game Over!")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
