//
//  ContentView.swift
//  MemoryMatchGame
//
//  Created by Skylar Beesley on 2/27/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CardGameViewModel()
    @State private var isLandscape: Bool = false
    
    var body: some View {
        // GeometryReader lets us read the screen zise for responsive layout
        GeometryReader { geo in
            ZStack {
                // Light blue background that fills the entire screen
                Color(red: 0.85, green: 0.93, blue: 1.0)
                    .ignoresSafeArea()
                
                // Switch between landscape and portrait layouts
                if isLandscape {
                    // Landscape: cards and control panel sit side by side
                    HStack(spacing: 16) {
                        cardGrid(screenSize: geo.size)
                        ControlPanel(viewModel: viewModel)
                            .frame(maxWidth: 200)
                            .padding(.trailing)
                        
                    }
                } else {
                    // Portrait: cards on top, control panel below
                    VStack(spacing: 16) {
                        cardGrid(screenSize: geo.size)
                        ControlPanel(viewModel: viewModel)
                            .padding(.horizontal)
                        }
                    }
                }
            // Check orientation as soon as the view appears
                .onAppear {
                        isLandscape = geo.size.width > geo.size.height
                }
            // update orientation whenever the screen size changes (device rotats)
                .onChange(of: geo.size) {
                    withAnimation(.spring()) {
                        isLandscape = geo.size.width > geo.size.height
                    }
                }
            }
        }
        // Builds the grid of cards basaed on current screen size and orientation
        @ViewBuilder
        private func cardGrid(screenSize: CGSize) -> some View {
            // Use wider cards in landscape, narrower in portrait
            let minCardWidth: CGFloat = isLandscape ? 100: 80
            // Adaptive olumns automatically fit as many cards per row as possible
            let columns = [GridItem(.adaptive(minimum: minCardWidth))]
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    // Create a CardView for each card in the game
                    ForEach(viewModel.cards) { card in
                        CardView(viewModel: viewModel, card: card)
                        // Maintain a 2:3 aspect ratio for all cards.
                            .aspectRatio(2/3, contentMode: .fit)
                            .padding(4)
                    }
                }
                .padding()
            }
        }
    }

#Preview {
    ContentView()
}
