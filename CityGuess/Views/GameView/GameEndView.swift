//
//  GameOverOver.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct GameEndView<ViewModel: CityGuessViewModel>: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text(viewModel.gameOverText)
                .font(.largeTitle)
                .padding()

            Text(viewModel.gameOverScoreText)
                .font(.headline)
                .padding()

            Button(viewModel.gameEndText) {
                withAnimation {
                    viewModel.endGame()
                    router.currentScreen = .menu
                }
            }
            .padding()

            LottieView(animationType: .skyscraper)
        }
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView(viewModel: TrainingViewModel())
    }
}
