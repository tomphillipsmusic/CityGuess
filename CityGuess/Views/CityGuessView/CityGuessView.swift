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
    @State private var showingNotice = false

    var body: some View {

        VStack {
            #warning("Replace with better way of giving user feedback on answers")
            Text(vm.priorAnswer)
                .foregroundColor(vm.isCorrect ? .green : .red)

            ZStack {
                ZoomableImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url))

                if showingNotice {
                    //LottieView(animationName: "correct")
                    withAnimation(.easeIn(duration: 1)) {
                        FloatingNotice(showingNotice: $showingNotice, isCorrect: vm.isCorrect, correctAnswer: vm.priorAnswer)

                    }
                }
            }

            CityGuessTextField(text: $guess)

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
    struct FloatingNotice: View {
        @Binding var showingNotice: Bool
        @State private var showingAnswer = true
        let isCorrect: Bool
        let correctAnswer: String

        var body: some View {
            ZStack {
                LottieView(animationName: isCorrect ? "correct" : "incorrect")
                
                if showingAnswer {
                    Text(correctAnswer)
                        .font(.largeTitle)
                        .padding()
                        .background(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5), style: .circular).foregroundColor(Color("Background")))
                        .padding()
                }

            }

            .transition(.scale)
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation(.easeOut(duration: 0.75)) {
                        self.showingNotice = false
                    }
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {

                })
            })
            .onChange(of: showingNotice) { newValue in
                if newValue {
                    withAnimation(.easeOut(duration: 3.0)) {
                        self.showingAnswer = false
                    }
                }
            }
        }
    }
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: TrainingViewModel())
    }
}
