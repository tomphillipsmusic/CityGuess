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
    @ObservedObject var viewModel: ViewModel
    @State private var hasUpdatedGauges = false
    @State private var screenshotMaker: ScreenshotMaker?
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            
            header
            Divider()
            progressGauges

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
                item: URL(string: "https://testflight.apple.com/join/9AOjhroT")!,
                subject: Text("Download City Guess"),
                message: Text("I just guessed \(viewModel.score) cities correctly on the City Guess Daily Challenge! How many can you guess?"),
                preview: SharePreview(
                    "Check Out My New Score!",
                    image: Image("cityguess-logo")))
        }
        .onAppear {
            UIApplication.shared.endEditing()
            historyManager.saveHistory()
            
            if let viewModel = viewModel as? DailyChallengeViewModel {
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
        .if(viewModel is DailyChallengeViewModel, transform: { view in
            view
                .sheet(isPresented: $firstTimeCompletingDailyChallenge) {
                    if let viewModel = viewModel as? DailyChallengeViewModel {
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
            Text(viewModel.selectedContinent.progressGaugeLabel)
                .font(.headline)
                .padding()

            let totalNumberOfCities = viewModel.totalNumberOfCities(in: viewModel.selectedContinent)
            let totalNumberOfCitiesGuessedCorrectly = historyManager.totalNumberOfCitiesGuessedCorrectly(in: viewModel.selectedContinent)
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
            viewModel.endGame()
            router.path.removeAll()
            router.path.append(Router.Screen.progressMap)
        }
        .padding()
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
    
    var shareableImage: Image {
        if let screenshotMaker, let screenshot = screenshotMaker.screenshot() {
            return Image(uiImage: screenshot)
        }
        
        return Image(uiImage: UIImage(named: "cityguess-logo") ?? UIImage())
    }
}

struct GameOverOver_Previews: PreviewProvider {
    static var previews: some View {
        GameEndView(viewModel: TrainingViewModel())
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
