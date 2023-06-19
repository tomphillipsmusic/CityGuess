//
//  MainMenuView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var trainingViewModel = TrainingViewModel()
    @StateObject var dailyChallengeViewModel = DailyChallengeViewModel()
    @StateObject var gameHistory = CityGuessGameHistoryManager()
    @StateObject var exploreCitiesViewModel = ExploreCitiesViewModel()
    @StateObject private var router = Router()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Group {
            switch router.currentScreen {
            case .menu:
                mainMenu
            case .training:
                GameView(viewModel: trainingViewModel)
            case .challenge:
                GameView(viewModel: dailyChallengeViewModel)
            case .explore:
                ExploreCitiesView(currentScreen: $router.currentScreen)
            }
        }
        .environmentObject(router)
        .environmentObject(gameHistory)
    }

    var mainMenu: some View {
        NavigationStack {
            ZStack {
                menuBackgroud

                VStack {
                    dailyChallengeButton

                    if dailyChallengeViewModel.isLocked {
                        Text(dailyChallengeViewModel.unlockText)
                    }

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
            .onAppear {
                LocalNotificationService.shared.requestNotificationPermission()
            }
            .navigationTitle("City Guess")
        }
    }

    var menuBackgroud: some View {
        Image("city-skyline-background")
            .resizable()
            .scaledToFill()
    }

    var dailyChallengeButton: some View {
        ZStack {
            MainMenuButton("Daily Challenge") {
                router.currentScreen = .challenge
            }
            .disabled(dailyChallengeViewModel.isLocked)
            .opacity(dailyChallengeViewModel.isLocked ? 0.8 : 1.0)

            if dailyChallengeViewModel.isLocked {
                LockView(progress: dailyChallengeViewModel.unlockProgress)
            }

        }
    }

    var trainingButton: some View {
        MainMenuButton("Training") {
            router.currentScreen = .training
        }
    }

    var exploreButton: some View {
        MainMenuButton("Explore Cities") {
            router.currentScreen = .explore
        }
        .disabled(gameHistory.guessHistory.isEmpty)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
