//
//  GameOverOver.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct GameEndView<ViewModel: CityGuessViewModel>: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) var reduceMotionEnabled
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            VStack {
                Text(viewModel.gameOverText)
                    .font(.largeTitle)
                    .padding()

                Text(viewModel.gameOverScoreText)
                    .font(.headline)
                    .padding()
            }

            if dynamicTypeSize < .accessibility5 && !reduceMotionEnabled {
                LottieView(animationType: .skyscraper)
            }

            Button(viewModel.gameEndText) {
                withAnimation {
                    viewModel.endGame()
                    router.path.removeLast()
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            UIApplication.shared.endEditing()

            if let viewModel = viewModel as? DailyChallengeViewModel {
                viewModel.scheduleNotification()
            }
        }
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView(viewModel: TrainingViewModel())
    }
}
