//
//  GameOverOver.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct GameEndView<ViewModel: CityGuessViewModel>: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) var reduceMotionEnabled
    @EnvironmentObject var historyManager: CityGuessGameHistoryManager
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: ViewModel
    @State private var hasUpdatedGauges = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            header
            Divider()
            progressGauges

            if dynamicTypeSize < .accessibility5 && !reduceMotionEnabled {
                LottieView(animationType: .skyscraper)
            }

            reviewCitiesButton
            endGameButton
        }
        .largeTextScrollView()
        .navigationBarBackButtonHidden()
        .onAppear {
            UIApplication.shared.endEditing()

            if let viewModel = viewModel as? DailyChallengeViewModel {
                viewModel.scheduleNotification()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    hasUpdatedGauges = true
                }
            }
        }
    }

    var header: some View {
        VStack {
            Text(viewModel.gameOverText)
                .font(.largeTitle)
                .padding()

            Text(viewModel.gameOverScoreText)
                .font(.title3)
                .padding()
        }
    }

    var progressGauges: some View {
        VStack {
            Text(historyManager.newCitiesGuessedCorrectlyLabel)
                .font(.headline)
                .padding()

            ProgressGauge(
                numberCompleted: hasUpdatedGauges ? historyManager.citiesGuessedCorrectly : historyManager.roundStartTotalCitiesGuessedCorrectly,
                totalNumber: historyManager.totalNumberOfCities,
                label: hasUpdatedGauges ? historyManager.totalCitiesGuessedCorrectlyText : ""
            )

            Text(historyManager.newCitiesSeenLabel)
                .font(.headline)
                .padding()

            ProgressGauge(
                numberCompleted: hasUpdatedGauges ? historyManager.totalCitiesSeen : historyManager.roundStartTotalCitiesGuessedCorrectly,
                totalNumber: historyManager.totalNumberOfCities,
                label: hasUpdatedGauges ? historyManager.totalCitiesSeenLabelText : ""
            )
        }
    }

    var reviewCitiesButton: some View {
        NavigationLink("Review Cities") {
            ReviewCitiesView()
        }
        .disabled(historyManager.roundHistory.isEmpty)
    }

    var endGameButton: some View {
        Button(viewModel.gameEndText) {
            withAnimation {
                viewModel.endGame()
                router.path.removeLast()
            }
        }
        .padding()
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView(viewModel: TrainingViewModel())
            .environmentObject(Router())
            .environmentObject(CityGuessGameHistoryManager())
    }
}
