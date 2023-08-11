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
        ZStack {
            backgroundImage

            VStack {
                Text(viewModel.gameHeadline)
                    .font(.title)
                    .padding()

                Text(viewModel.gameDescription)
                    .font(.headline)

                VStack(alignment: .leading) {
                    if viewModel is TrainingViewModel {
                        continentPicker
                    }

                    if viewModel.roundOptions.count > 1 {
                        roundOptionsPicker
                    }
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
            .animation(.linear, value: viewModel.selectedContinent)
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

    var roundOptionsPicker: some View {
        HStack {
            Text("Number of Cities:")
            Spacer()
            Picker("Number of Cities", selection: $viewModel.numberOfRounds) {
                ForEach(viewModel.roundOptions, id: \.self) {
                    Text("\($0)")
                        .tag($0)
                }
                .onChange(of: viewModel.numberOfRounds) { newValue in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.questions = Array(repeating: Question(text: ""), count: newValue)
                    }
                }
            }
            .disabled(viewModel.roundOptions.count <= 1)
        }
    }

    var continentPicker: some View {
        HStack {
            Text("Continent:")
            Spacer()
            Picker("Continent", selection: $viewModel.selectedContinent) {
                ForEach(CGCity.Continent.allCases, id: \.self) { continent in
                    Text(continent.rawValue)
                        .tag(continent)
                }
            }
            .onChange(of: viewModel.selectedContinent) { _ in
                 viewModel.numberOfRounds = viewModel.roundOptions[0]
            }
        }
    }

    var gameStartButton: some View {
        Button(viewModel.startGameButtonText) {
            viewModel.startGame(with: viewModel.numberOfRounds)
            historyManager.resetRoundHistory(withTotalNumberOfCities: viewModel.cities.count)
        }
        .disabled(viewModel.filteredCityImages.isEmpty)
        .padding()
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView(viewModel: TrainingViewModel())
    }
}
