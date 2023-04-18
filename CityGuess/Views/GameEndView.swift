//
//  GameOverOver.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct GameEndView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            Text(vm.gameOverText)
                .font(.largeTitle)
                .padding()
            
            Text(vm.gameOverScoreText)
                .font(.headline)
                .padding()
            
            Button(vm.tryAgainButtonText) {
                vm.endGame()
            }
            .padding()
        }
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView(vm: TrainingViewModel())
    }
}