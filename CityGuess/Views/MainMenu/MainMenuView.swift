//
//  MainMenuView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("firstTime") var isShowingInfoSheet = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @StateObject var trainingViewModel = TrainingViewModel()
    @StateObject var dailyChallengeViewModel = DailyChallengeViewModel()
    @StateObject var gameHistory = CityGuessGameHistoryManager()
    @StateObject var exploreCitiesViewModel = ExploreCitiesViewModel()
    @StateObject private var router = Router()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack(path: $router.path) {
            mainMenu
                .navigationDestination(for: Router.Screen.self) { screen in
                    switch screen {
                    case .training:
                        GameView(viewModel: trainingViewModel)
                    case .challenge:
                        GameView(viewModel: dailyChallengeViewModel)
                    case .explore:
                        ExploreCitiesView()
                    }
                }
                .toolbar {
                    Button {
                        isShowingInfoSheet = true
                    } label: {
                        Image(systemName: "questionmark.app")
                    }

                }
                .sheet(isPresented: $isShowingInfoSheet) {
                    OnboardingView(firstTime: $isShowingInfoSheet)
                }
        }
        .environmentObject(router)
        .environmentObject(gameHistory)
    }

    var mainMenu: some View {
        ZStack {
            if dynamicTypeSize < .accessibility1 {
                menuBackgroud
            }

            VStack {
                dailyChallengeButton
                trainingButton
                exploreButton

                Spacer().frame(height: UIScreen.main.bounds.height * 0.4)
            }
        }
        .onReceive(timer, perform: { _ in
            withAnimation {
                dailyChallengeViewModel.calculateUnlockProgress()
            }
        })
        .navigationTitle("City Guess")
    }

    var menuBackgroud: some View {
        Image("city-skyline-background")
            .resizable()
            .scaledToFill()
            .if(colorScheme == .dark) { view in
                view.colorInvert()
                    .opacity(0.8)
                    .blur(radius: 0.1)
            }
    }

    var dailyChallengeButton: some View {
        ZStack {
            MainMenuButton("Daily Challenge") {
                router.path.append(Router.Screen.challenge)
            }
            .disabled(dailyChallengeViewModel.isLocked)
            .opacity(dailyChallengeViewModel.isLocked ? 0.8 : 1.0)

            if dailyChallengeViewModel.isLocked {
                LockView(progress: dailyChallengeViewModel.unlockProgress)
                    .if(colorScheme == .dark) { view in
                        view.colorInvert()
                    }
            }

        }
    }

    var trainingButton: some View {
        MainMenuButton("Training") {
            router.path.append(Router.Screen.training)
        }
    }

    var exploreButton: some View {
        MainMenuButton("Explore Cities") {
            router.path.append(Router.Screen.explore)
        }
        .disabled(gameHistory.guessHistory.isEmpty)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
