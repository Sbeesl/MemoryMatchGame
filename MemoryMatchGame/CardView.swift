//
//  CardView.swift
//  MemoryMatchGame
//
//  Created by Skylar Beesley on 2/27/26.
//

import SwiftUI

struct CardView: View {
    // Observes the view model so the card updates when game state changes
    @ObservedObject var viewModel: CardGameViewModel
    // The specific card this view represnets
    let card: Card
    // Tracks how far the card has been dragged from its original position
    @State private var dragAmount: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
            // Card back is visible when face down, hidden when face up
            cardBack
            // Card front is visible when face up, hidden when face down
            cardFront
        }
        
        .frame(width: geo.size.width, height: geo.size.height)
        // 3D flip animation along the Y axis to simulate a real card flip
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        
        // Offset moves the card as the player drags it
        .offset(dragAmount)
        // Drag gesture lets the player move the card around the screen
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragAmount = value.translation
                }
            // Card snaps back to original position when released
                .onEnded { _ in
                    withAnimation(.spring()) {
                        dragAmount = .zero
                    }
                }
            )
            // Double tap flips the card and triggers game logic
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        viewModel.selectCard(card)
                        }
                    }
            )
            // Matched cards become semi-transparent to show they are completed
                .opacity(card.isMatched ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 0.4), value: card.isFaceUp)
            }
        }
        // Mark - Card Front
        // Shows the emoji and is only visible when the card is face up
    private var cardFront: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(card.isMatched ? Color(white: 0.88) : Color.white)
            .overlay(
                Text(card.content)
                    .font(.largeTitle)
                    .opacity(card.isMatched ? 0.6 : 1.0)
            )
            .shadow(radius: card.isMatched ? 1 : 3)
            .opacity(card.isFaceUp ? 1 : 0)
        }
        // Mark - Card Back
        // Shows the striped blue pattern and is only visible when the card is face down
        private var cardBack: some View {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue)
                .overlay(StripedPattern())
                .shadow(radius: 3)
                .opacity(card.isFaceUp ? 0 : 1)
        }
    }
    // Mark - Striped Pattern
    // Creates the stripe pattern displayed on the back of each card
struct StripedPattern: View {
    var body: some View {
        GeometryReader { geo in
            let stripeWidth: CGFloat = 6
            let gap: CGFloat = 6
            let total = stripeWidth + gap
            // Calculate how many stripes are needed to fill the card width
            let count = Int(geo.size.width / total) + 2
            
            HStack(spacing: gap) {
                ForEach(0..<count, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: stripeWidth)
                }
            }
            .frame(maxHeight: .infinity)
        }
        // Clip the stripes to the card's rounded corners
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
    
    
