//
//  GameConfigurationPickers.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/11/23.
//

import SwiftUI

struct GameConfigurationPickers<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel is TrainingViewModel {
                continentPicker
            }

            roundOptionsPicker
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
                if let viewModel = viewModel as? TrainingViewModel {
                    viewModel.filterCityImages()

                }
            }
        }
    }
}

struct GameConfigurationPickers_Previews: PreviewProvider {
    static var previews: some View {
        GameConfigurationPickers(viewModel: TrainingViewModel())
    }
}
