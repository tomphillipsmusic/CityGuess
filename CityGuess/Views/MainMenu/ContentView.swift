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
    @StateObject var router = Router()

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
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
