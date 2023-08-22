//
//  GameStartView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI

struct GameStartView<ViewModel: CityGuessViewModel>: View {
    @EnvironmentObject var historyManager: CityGuessGameHistoryManager
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            ProgressBar(progress: viewModel.gameProgress, questions: viewModel.questions)
                .frame(height: 20)
                .padding()

            ZStack {
                backgroundImage

                VStack {
                    Text(viewModel.gameHeadline)
                        .font(.title)
                        .padding()

                    Text(viewModel.gameDescription)
                        .font(.headline)

                    if viewModel is TrainingViewModel {
                        GameConfigurationPickers(viewModel: viewModel)
                    }

                    gameStartButton
                }
                .padding()
                .largeTextScrollView(whenBiggerThan: .accessibilityLarge)
                .background(
                    .background
                        .opacity(0.9)
                )
                .cornerRadius(5)
                .shadow(radius: 0.2)
                .animation(.default, value: viewModel.selectedContinent)
            }
        }
    }

    var backgroundImage: some View {
        AsyncImage(url: URL(string: viewModel.cityImages.randomElement()?.url ?? "")) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width)
                .opacity(0.8)
        } placeholder: {
            Color.secondary
        }
    }

    var gameStartButton: some View {
        HStack {
            Spacer()
            Button(viewModel.startGameButtonText) {
                startGamePressed()
            }
            .disabled(viewModel.filteredCityImages.isEmpty)
            .padding()

            if viewModel.filteredCityImages.isEmpty {
                ProgressView()
            }

            Spacer()
        }

    }

    func startGamePressed() {
        viewModel.startGame(with: viewModel.numberOfRounds)
        let totalCities = viewModel.totalNumberOfCities(in: .all)
        let totalGuessedCorrectly = historyManager.numberOfCitiesGuessedCorrectly(in: viewModel.selectedContinent)
        historyManager.resetRoundHistory(totalNumber: totalCities, totalGuessedCorrectly: totalGuessedCorrectly)
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView(viewModel: TrainingViewModel())
    }
}
