//
//  GameOverOver.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct GameOverOver: View {
    @ObservedObject var vm: CityGuessViewModel<TeleportCity>
    
    var body: some View {
        VStack {
            Text("Game Over!")
                .font(.largeTitle)
                .padding()
            
            Text("You guessed a total of \(vm.score) cities correctly!")
                .font(.headline)
                .padding()
            
            Button("Train Again?") {
                vm.endGame()
            }
            .padding()
        }
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameOverOver(vm: CityGuessViewModel())
    }
}
