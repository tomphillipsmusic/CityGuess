//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct CityGuessView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var guess = ""
    @State var lastScaleValue: CGFloat = 1.0
    @State private var autofillSuggestions = [ViewModel.CityModel]()

    var body: some View {

        VStack {

            ZStack {
                ZoomableImage(url: URL(string: viewModel.currentCityImage.url))

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
                }

                self.guess = ""
            }
        }
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
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(viewModel: TrainingViewModel())
    }
}
