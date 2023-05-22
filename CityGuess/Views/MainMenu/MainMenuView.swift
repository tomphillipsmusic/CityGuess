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
                Image("city-skyline-background")
                    .resizable()
                    .scaledToFill()

                VStack {

                    Button("Training") {
                        router.currentScreen = .training
                    }
                    .buttonStyle(.bordered)
                    .padding()

                    ZStack {
                        Button("Daily Challenge") {
                            router.currentScreen = .challenge
                        }
                        .disabled(dailyChallengeViewModel.isLocked)
                        .opacity(dailyChallengeViewModel.isLocked ? 0.8 : 1.0)
                        .buttonStyle(.bordered)
                        .padding()

                        if dailyChallengeViewModel.isLocked {

                            Image("lock")
                                .resizable()
                                .frame(width: 50, height: 50)
                            ActivityRingView(progress: dailyChallengeViewModel.unlockProgress, gradientColors: [.red, .green], outlineColor: .gray.opacity(0.5), lineWidth: 10)
                                .frame(width: 100, height: 100)
                        }

                    }

                    if dailyChallengeViewModel.isLocked {
                        Text("Daily Challenge will unlock in \(Date(timeIntervalSince1970: dailyChallengeViewModel.unlockInterval).formatted())")
                    }

                    Spacer().frame(height: UIScreen.main.bounds.height * 0.4)
                }
            }
            .onReceive(timer, perform: { _ in
                print(dailyChallengeViewModel.unlockProgress)
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

}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
