//
//  Onboarding.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/6/23.
//

import SwiftUI

struct Onboarding {
    let title: String
    let description: String
    let image: Image
    let details: [Detail]
    let closeButtonLabel: String

    struct Detail: Identifiable {
        let id = UUID()
        let symbol: String
        let text: String
        let color: Color
    }
}

extension Onboarding {
    static let cityGuessOnboarding = Onboarding(
        title: "Welcome to City Guess!",
        description: """
                     A fun game to test how well you can recognize photos of cities from all
                     over the world! Can you correctly guess all of the cities and become a
                     true city guesser?
                    """,
        image: Image(systemName: "building.2"),
        details: [
                Detail(
                    symbol: "medal",
                    text: "The daily challenge will test you with new photos every single day",
                    color: .green
                ),
                Detail(
                    symbol: "figure.run",
                    text: "Train anytime to test your knowledge of all of the cities and discover new cities",
                    color: .green
                ),
                Detail(
                    symbol: "globe",
                    text: "Unlock all of the cities on the world map and track your progress as you play",
                    color: .green
                )
        ],
        closeButtonLabel: "Start Guessing!")

    static let exploreCitiesOnboarding = Onboarding(
        title: "Explore Cities",
        description: "",
        image: Image(systemName: "map.fill"),
        details: [
                Detail(
                    symbol: "globe",
                    text: "As you see cities in the game, their icons will appear on the map",
                    color: .green
                ),
                Detail(
                    symbol: "building",
                    text: "Tap an icon to see how many times you have guessed that city correctly",
                    color: .green
                ),
                Detail(
                    symbol: "medal",
                    text: "Track your progress as you try to guess every city correctly!",
                    color: .green
                )
        ],
        closeButtonLabel: "Start Exploring!"
    )
}
