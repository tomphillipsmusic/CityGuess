//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI

struct CityGuessView<ViewModel: CityGuessViewModel>: View {
    @EnvironmentObject var gameHistory: CityGuessGameHistoryManager
    @ObservedObject var viewModel: ViewModel
    @State private var guess = ""
    @State var lastScaleValue: CGFloat = 1.0
    @State private var autofillSuggestions = [ViewModel.CityModel]()
    let image: Image

    var body: some View {

        VStack {
            ZStack {
                ZoomableScrollView {
                    image
                        .resizable()
                        .scaledToFit()
                }

                if viewModel.isShowingAnimation {
                    withAnimation(.easeIn(duration: 1)) {
                        FloatingAnimationView(viewModel: viewModel)
                    }
                }
            }

            CityGuessTextField(text: $guess, isLoadingNextQuestion: $viewModel.isShowingAnimation)

            AutofillSuggestionsView(autofillSuggestions: autofillSuggestions) { cityName in
                withAnimation(.linear(duration: 1.0)) {
                    viewModel.submit(guess: cityName)
                    if let formattedImage = formatImageForHistoryStorage(ofCityNamed: cityName) {
                        gameHistory.updateHistory(forImage: formattedImage, with: viewModel.isCorrect ? .right : .wrong)
                    }
                }

                self.guess = ""
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            scoreLabel
            roundCounterLabel
        }
        .onChange(of: guess) { guess in
            withAnimation {
                autofillSuggestions = viewModel.autofillSuggestions(for: guess)
            }
        }

    }

    var scoreLabel: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(viewModel.scoreLabelText)
                    .font(.title2)
            }
    }

    var roundCounterLabel: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text(viewModel.roundLabelText)
                .font(.title3)
        }
    }

    func formatImageForHistoryStorage(ofCityNamed cityName: String) -> CityImage? {
        let image: CityImage

        // Replaces image name with name of the city since the city name is the key of the history dictionary
        if viewModel.isCorrect {
            image = CityImage(title: cityName, url: viewModel.currentCityImage.url)
        } else {

            if let correctCityName = viewModel.cities.first(where: { city in viewModel.currentCityImage.title.caseInsensitiveContains(city.name)
            })?.name {
                image = CityImage(title: correctCityName, url: viewModel.currentCityImage.url)
            } else {
                return nil
            }
        }

        return image
    }
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(viewModel: TrainingViewModel(), image: Image(systemName: "building"))
    }
}
