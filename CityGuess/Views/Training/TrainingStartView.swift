//
//  GameStartView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct TrainingStartView: View {
    @ObservedObject var vm: TrainingViewModel
    @State private var numberOfRounds = 10

    var body: some View {
        ZStack {
            CachedAsyncImage(url: URL(string: vm.cityImages.randomElement()?.url ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .opacity(0.8)
            } placeholder: {
                Color.secondary
            }
            VStack {
                

                Text("Do you have what it takes to be a true City Guesser?")
                    .font(.title)
                    .padding()
                
                Text("Take a spin through our images of famous cities from around the world and do your best to guess the name of the city!")
                    .font(.headline)
                    .padding()
                
                HStack {
                    Text("Number of Cities:")
                    
                    Picker("Number of Cities", selection: $numberOfRounds) {
                        ForEach(vm.roundOptions, id: \.self) {
                            Text("\($0)")
                                .tag($0)
                        }
                    }
                }
                
                
                
                Button("Start Training!") {
                    vm.startGame(with: numberOfRounds)
                }
                .disabled(vm.cityImages.isEmpty)
                .padding()
            }
            .background(
                .background
                    .opacity(0.9)
            )
        }
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingStartView(vm: TrainingViewModel())
    }
}
