//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct CityGuessView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var vm: ViewModel
    @State private var guess = ""
    @State var lastScaleValue: CGFloat = 1.0
    @State private var autofillSuggestions = [ViewModel.CityModel]()

    var body: some View {

        VStack {

            ZStack {
                ZoomableImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url))

                if vm.isShowingAnimation {
                    withAnimation(.easeIn(duration: 1)) {
                        FloatingAnimationView(vm: vm)
                    }
                }
            }

            CityGuessTextField(text: $guess, isLoadingNextQuestion: $vm.isShowingAnimation)

            AutofillSuggestionsView(autofillSuggestions: autofillSuggestions) { cityName in
                vm.submit(guess: cityName)
                self.guess = ""
            }
        }
        .toolbar {
            scoreLabel
            roundCounterLabel
        }
        .onChange(of: guess) { guess in
            withAnimation {
                autofillSuggestions = vm.autofillSuggestions(for: guess)
            }
        }

    }

    var scoreLabel: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(vm.scoreLabelText)
                    .font(.title2)
            }
    }

    var roundCounterLabel: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text(vm.roundLabelText)
                .font(.title3)
        }
    }
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: TrainingViewModel())
    }
}
