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
    @StateObject private var router = Router()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Group {
            switch router.currentScreen {
            case .menu:
                mainMenu
            case .training:
                GameView(vm: trainingViewModel)
            case .challenge:
                GameView(vm: dailyChallengeViewModel)
            }
        }
        .environmentObject(router)
    }

    var mainMenu: some View {
        NavigationStack {
            ZStack {
                menuBackgroud

                VStack {
                    trainingButton
                    dailyChallengeButton

                    if dailyChallengeViewModel.isLocked {
                        Text(dailyChallengeViewModel.unlockText)
                    }

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

    var trainingButton: some View {
        MainMenuButton("Training") {
            router.currentScreen = .training
        }
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

}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
