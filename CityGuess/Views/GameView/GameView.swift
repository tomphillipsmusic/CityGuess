//
//  ContentView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/6/23.
//

import SwiftUI

struct GameView<ViewModel: CityGuessViewModel>: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            ProgressBar(progress: viewModel.gameProgress, questions: viewModel.questions)
                .frame(height: 20)
                .padding()

            if !viewModel.isPlaying {
                GameStartView(viewModel: viewModel)
            } else if viewModel.isGameOver {
                GameEndView(viewModel: viewModel)
            } else {
                loadGameView
            }
        }
        .navigationTitle(viewModel.modeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchCityImages()
        }
    }

    var loadGameView: some View {
        AsyncImage(url: URL(string: viewModel.currentCityImage.url)) { phase in
            switch phase {
            case .success(let image):
                CityGuessView(viewModel: viewModel, image: image)
            case .empty:
                loadingView
            case .failure(let error):
                GameErrorView(error: error, confirmationMessage: "Return Home") {
                    router.path.removeLast()
                    viewModel.endGame()
                }
            @unknown default:
                Text("Unknown error has occured")
            }
        }
    }

    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: TrainingViewModel())
    }
}
