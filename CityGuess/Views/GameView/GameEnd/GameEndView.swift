//
//  GameOverOver.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct GameEndView<ViewModel: CityGuessViewModel>: View {
    @AppStorage("firstTimeCompletingDailyChallange") var firstTimeCompletingDailyChallenge = true
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) var reduceMotionEnabled
    @EnvironmentObject var historyManager: CityGuessGameHistoryManager
    @EnvironmentObject var router: Router
    @ObservedObject var gameViewModel: ViewModel
    @State private var hasUpdatedGauges = false
    @State private var screenshotMaker: ScreenshotMaker?

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {

            VStack {
                ProgressBar(progress: gameViewModel.gameProgress, questions: gameViewModel.questions)
                    .frame(height: 20)
                    .padding()

                header
                Divider()
                progressGauges
            }
            .screenshotView { screenshotMaker in
                self.screenshotMaker = screenshotMaker
            }

            if !reduceMotionEnabled {
                let animation = animation
                LottieView(animationType: animation.type, removeWhenFinished: animation.removeWhenFinished)
            }

            reviewCitiesButton
            checkProgressButton
            endGameButton
        }
        .largeTextScrollView()
        .navigationBarBackButtonHidden()
        .toolbar {
            shareLink
        }
        .onAppear {
            UIApplication.shared.endEditing()
            historyManager.saveHistory()

            if let viewModel = gameViewModel as? DailyChallengeViewModel {
                if !firstTimeCompletingDailyChallenge {
                    viewModel.scheduleNotification()
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    hasUpdatedGauges = true
                }
            }
        }
        .if(gameViewModel is DailyChallengeViewModel, transform: { view in
            view
                .sheet(isPresented: $firstTimeCompletingDailyChallenge) {
                    if let viewModel = gameViewModel as? DailyChallengeViewModel {
                        DismissableMessage(message: viewModel.notificationDescription) {
                            viewModel.scheduleNotification()
                            firstTimeCompletingDailyChallenge = false
                        }
                    }
                }
        })
    }

    var header: some View {
        VStack {
            Text(isPerfectGame ? "Perfect Game!" : gameViewModel.gameOverText)
                .font(.largeTitle)
                .padding()

            Text(gameViewModel.gameOverScoreText)
                .font(.title3)
                .padding()
        }
    }

    var progressGauges: some View {
        VStack {
            Text(progressGaugeLabel)
                .font(.headline)

            ProgressGauge(
                numberCompleted: totalNumberOfCitiesGuessedCorrectly,
                totalNumber: totalNumberOfCities,
                label: "\(totalNumberOfCitiesGuessedCorrectly) / \(totalNumberOfCities)"
            )
        }
    }

    var reviewCitiesButton: some View {
        NavigationLink("Review Cities") {
            ReviewCitiesView()
        }
        .padding()
        .disabled(historyManager.roundHistory.isEmpty)
    }

    var checkProgressButton: some View {
        Button("Check Progress") {
            gameViewModel.endGame()
            router.path.removeAll()
            router.path.append(Router.Screen.progressMap)
        }
        .padding()
    }

    var endGameButton: some View {
        Button(gameViewModel.gameEndText) {
            withAnimation {
                gameViewModel.endGame()
                router.path.removeLast()
            }
        }
        .padding()
    }

    var shareLink: some View {
        ShareLink(
            item: shareableImage,
            subject: Text("Share score"),
            message: Text("I just guessed \(gameViewModel.score) cities correctly on City Guess!"),
            preview: SharePreview(
                "Check Out My New Score!",
                image: Image("cityguess-logo")))
    }
}

// MARK: View Computed Properties
extension GameEndView {

    var totalNumberOfCities: Int {
        gameViewModel.totalNumberOfCities(in: gameViewModel.selectedContinent)
    }

    var totalNumberOfCitiesGuessedCorrectly: Int {
        if hasUpdatedGauges {
            return historyManager.numberOfCitiesGuessedCorrectly(in: gameViewModel.selectedContinent)
        } else {
            return historyManager.roundStartTotalCitiesGuessedCorrectly
        }
    }

    var progressGaugeLabel: String {
        if dynamicTypeSize > .large {
            return gameViewModel.selectedContinent.progressGaugeLabel
        } else {
            return gameViewModel.selectedContinent.progressGaugeLabel +
            " \(totalNumberOfCitiesGuessedCorrectly) / \(totalNumberOfCities)"
        }
    }

    var shareableImage: Image {
        if let screenshotMaker, let screenshot = screenshotMaker.screenshot() {
            return Image(uiImage: screenshot)
        }

        return Image(uiImage: UIImage(named: "cityguess-logo") ?? UIImage())
    }

    var isPerfectGame: Bool {
        gameViewModel.score == gameViewModel.numberOfRounds
    }

    var isProgressGaugeFilledUpForTheFirstTime: Bool {
        let totalCities = gameViewModel.totalNumberOfCities(in: gameViewModel.selectedContinent)
        let totalGuessedCorrectly = historyManager.numberOfCitiesGuessedCorrectly(in: gameViewModel.selectedContinent)
        let hasNotFilledUpGaugeBefore = historyManager.roundStartTotalCitiesGuessedCorrectly < totalCities
        let hasGuessedEveryCityCorrectly = totalGuessedCorrectly == totalCities
        return hasNotFilledUpGaugeBefore && hasGuessedEveryCityCorrectly
    }

    var animation: (type: AnimationType, removeWhenFinished: Bool) {
        if isProgressGaugeFilledUpForTheFirstTime {
            HapticsManager.shared.correct()
            return (.trophy, false)
        } else if isPerfectGame {
            HapticsManager.shared.correct()
            return (.perfect, true)
        } else {
            return (.skyscraper, false)
        }
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView(gameViewModel: TrainingViewModel())
            .environmentObject(Router())
            .environmentObject(CityGuessGameHistoryManager())
    }
}
