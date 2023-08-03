//
//  MainMenuView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/6/23.
//

import SwiftUI

extension ContentView {
    var mainMenu: some View {
        ZStack {
            menuBackgroud

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
                LockView(
                    progress: dailyChallengeViewModel.unlockProgress,
                    unlockHint: dailyChallengeViewModel.unlockText
                )
            }

        }
    }

    var trainingButton: some View {
        MainMenuButton("Training") {
            router.path.append(Router.Screen.training)
        }
    }

    var exploreButton: some View {
        let isLocked = gameHistory.guessHistory.isEmpty

        return ZStack {
            MainMenuButton("Progress Map") {
                router.path.append(Router.Screen.explore)
            }
            .disabled(isLocked)
            .opacity(isLocked ? 0.8 : 1.0)

            if isLocked {
                LockView(
                    progress: 0.0,
                    unlockHint: exploreCitiesViewModel.unlockText
                )
            }
        }
    }
}
