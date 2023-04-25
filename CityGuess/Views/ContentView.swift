//
//  ContentView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GameView(vm: TrainingViewModel())
                .tabItem {
                    Label("Training", systemImage: "globe.americas.fill")
                }

            GameView(vm: DailyChallengeViewModel())
                .tabItem {
                    Label("Daily Challenge", systemImage: "medal")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
