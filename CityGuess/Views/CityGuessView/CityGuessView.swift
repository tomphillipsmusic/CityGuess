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
    @State private var showingNotice

    var body: some View {

        VStack {
            #warning("Replace with better way of giving user feedback on answers")
            Text(vm.priorAnswer)
                .foregroundColor(vm.isCorrect ? .green : .red)

            ZStack {
                ZoomableImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url))

                if showingNotice {
                    withAnimation(.easeIn(duration: 1)) {
                        FloatingAnimationView( isShowing: $showingNotice, isCorrect: vm.isCorrect, correctAnswer: vm.priorAnswer)

                    }
                }
            }

            CityGuessTextField(text: $guess, isLoadingNextQuestion: $showingNotice)
                .disabled(showingNotice)

            AutofillSuggestionsView(autofillSuggestions: autofillSuggestions) { cityName in
                vm.submit(guess: cityName)
                self.guess = ""
                showingNotice = true
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
