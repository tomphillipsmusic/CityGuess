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
    @State private var autofillSuggestions = [CGCity]()
    @State private var isShowingExitAlert = false
    let image: Image

    var body: some View {

        VStack {
            ZStack {
                ZoomableScrollView(isNewImage: $viewModel.isShowingNewImage) {
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

            AutofillSuggestionsView(autofillSuggestions: autofillSuggestions) { city in
                handle(guess: city)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            scoreLabel
            quitButton
        }
        .alert("Stop Playing?", isPresented: $isShowingExitAlert, actions: {
            Button("Continue Playing", role: .cancel) {}

            Button(role: .destructive) {
                viewModel.endGame()
            } label: {
                Text("End Game")
            }
        }, message: {
            Text("If you end the game, cities you have seen and guessed will not be saved.")
        })
        .onChange(of: guess) { guess in
            withAnimation {
                autofillSuggestions = viewModel.autofillSuggestions(for: guess)
            }
        }

    }

    var scoreLabel: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(viewModel.scoreLabelText)
            }
    }

    var quitButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                isShowingExitAlert = true
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .bold()
                }
            }

        }
    }

    func handle(guess: CGCity) {
        withAnimation(.linear(duration: 1.0)) {
            viewModel.submit(guess: guess.name)
            if let formattedImage = formatImageForHistoryStorage(ofCityNamed: viewModel.currentCityImage.title),
                let correctCity = viewModel.cities.first(where: { $0.name == formattedImage.title }) {
                gameHistory.updateHistory(
                    forImage: formattedImage,
                    with: correctCity.continent,
                    and: viewModel.isCorrect ? .right : .wrong
                )
            }
        }

        self.guess = ""
    }

    func formatImageForHistoryStorage(ofCityNamed cityName: String) -> CityImage? {
        let image: CityImage

        // Replaces image name with name of the city since the city name is the key of the history dictionary
        if viewModel.isCorrect {
            image = CityImage(title: cityName, url: viewModel.currentCityImage.url)
        } else {

            if let correctCityName = viewModel.cities.first(where: { city in
                viewModel.currentCityImage.title.caseInsensitiveContains(city.name)
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
        NavigationStack {
            CityGuessView(viewModel: TrainingViewModel(), image: Image(systemName: "building"))
                .navigationTitle("Training")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
