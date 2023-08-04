//
//  CityGuessApp.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/6/23.
//

import SwiftUI

@main
struct CityGuessApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        let continents = try await TeleportContinentService().fetchContinents()
                        print(continents)
                    } catch {
                        print(error)
                    }

                }
        }
    }
}
