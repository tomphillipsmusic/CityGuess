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

            if dynamicTypeSize < .accessibility5 && !reduceMotionEnabled {
                LottieView(animationType: .skyscraper, removeWhenFinished: false)
            }

            reviewCitiesButton
            checkProgressButton
            endGameButton
        }
        .largeTextScrollView()
        .navigationBarBackButtonHidden()
        .toolbar {
            ShareLink(
                item: shareableImage,
                subject: Text("Share score"),
                message: Text("I just guessed \(gameViewModel.score) cities correctly on City Guess!"),
                preview: SharePreview(
                    "Check Out My New Score!",
                    image: Image("cityguess-logo")))
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
        .screenshotView { screenshotMaker in
            self.screenshotMaker = screenshotMaker
        }
    }

    var header: some View {
        VStack {
            Text(gameViewModel.gameOverText)
                .font(.largeTitle)
                .padding()

            Text(gameViewModel.gameOverScoreText)
                .font(.title3)
                .padding()
        }
    }

    var progressGauges: some View {
        VStack {
            let totalNumberOfCities = gameViewModel.totalNumberOfCities(in: gameViewModel.selectedContinent)
            let totalNumberOfCitiesGuessedCorrectly = historyManager.totalNumberOfCitiesGuessedCorrectly(in: gameViewModel.selectedContinent)
            Text("\(gameViewModel.selectedContinent.progressGaugeLabel) \(totalNumberOfCitiesGuessedCorrectly) / \(totalNumberOfCities)")
                .font(.headline)
                .padding()

            ProgressGauge(
                numberCompleted: totalNumberOfCitiesGuessedCorrectly,
                totalNumber: totalNumberOfCities,
                label: "\(totalNumberOfCitiesGuessedCorrectly)/\(totalNumberOfCities)"
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

    var shareableImage: Image {
        if let screenshotMaker, let screenshot = screenshotMaker.screenshot() {
            return Image(uiImage: screenshot)
        }

        return Image(uiImage: UIImage(named: "cityguess-logo") ?? UIImage())
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView(gameViewModel: TrainingViewModel())
            .environmentObject(Router())
            .environmentObject(CityGuessGameHistoryManager())
    }
}

typealias ScreenshotMakerClosure = (ScreenshotMaker) -> Void

struct ScreenshotMakerView: UIViewRepresentable {
    let closure: ScreenshotMakerClosure

    init(_ closure: @escaping ScreenshotMakerClosure) {
        self.closure = closure
    }

    func makeUIView(context: Context) -> ScreenshotMaker {
        let view = ScreenshotMaker(frame: CGRect.zero)
        return view
    }

    func updateUIView(_ uiView: ScreenshotMaker, context: Context) {
        DispatchQueue.main.async {
            closure(uiView)
        }
    }
}

class ScreenshotMaker: UIView {
    /// Takes the screenshot of the superview of this superview
    /// - Returns: The UIImage with the screenshot of the view
    func screenshot() -> UIImage? {
        guard let containerView = self.superview?.superview,
              let containerSuperview = containerView.superview else { return nil }
        let renderer = UIGraphicsImageRenderer(bounds: containerView.frame)
        return renderer.image { (context) in
            containerSuperview.layer.render(in: context.cgContext)
        }
    }
}

extension View {
    func screenshotView(_ closure: @escaping ScreenshotMakerClosure) -> some View {
        let screenshotView = ScreenshotMakerView(closure)
        return overlay(screenshotView.allowsHitTesting(false))
    }
}
