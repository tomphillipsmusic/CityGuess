//
//  MainMenuView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/3/23.
//

import SwiftUI

class Router: ObservableObject {
    @Published var currentScreen: Screen = .menu

    enum Screen {
        case menu, training, challenge
    }
}

struct MainMenuView: View {
    @StateObject var trainingViewModel = TrainingViewModel()
    @StateObject var dailyChallengeViewModel = DailyChallengeViewModel()
    @StateObject private var router = Router()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Group {
            switch router.currentScreen {
            case .menu:
                NavigationStack {
                    ZStack {
                        Image("city-skyline-background")
                            .resizable()
                            .scaledToFill()

                        VStack {

                            Text("\(dailyChallengeViewModel.unlockInterval)")
                            Text("\(Date().timeIntervalSince1970)")

                            Button("Training") {
                                router.currentScreen = .training
                            }
                            .buttonStyle(.bordered)
                            .padding()

                            ZStack {
                                if dailyChallengeViewModel.isLocked {
                                    Image("lock")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }

                                Button("Daily Challenge") {
                                    router.currentScreen = .challenge
                                }
                                .disabled(dailyChallengeViewModel.isLocked)
                                .buttonStyle(.bordered)
                                .padding()
                            }

                            Button("Lock") {
                                withAnimation {
                                    dailyChallengeViewModel.unlockInterval = Date().timeIntervalSinceNow - 5
                                }
                            }

                            Spacer().frame(height: UIScreen.main.bounds.height * 0.4)
                        }
                    }
                    .onReceive(timer, perform: { _ in
                        dailyChallengeViewModel.unlockInterval += 1
                    })
                    .navigationTitle("City Guess")
                }

            case .training:
                GameView(vm: trainingViewModel)
            case .challenge:
                GameView(vm: dailyChallengeViewModel)

            }
        }
        .environmentObject(router)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
