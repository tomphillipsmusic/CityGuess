//
//  LearnMoreViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import SwiftUI

class LearnMoreViewModel: ViewModel {
    @Published var cityScores: [CityScore] = []

    let city: TeleportCity
    let guessHistory: CityGuessHistory

    var cityName: String {
        city.name
    }

    var guessHistoryLabel: String {
        guessHistory.label
    }

    var guessHistoryLabelColor: Color {
        guessHistory.guessStatus.color
    }

    var imageUrl: URL? {
        URL(string: guessHistory.urlString)
    }

    var learnMoreUrl: URL? {
        var cityName = city.name
        if cityName.contains(" ") {
            cityName = cityName.replacingOccurrences(of: " ", with: "_")
        }

        return URL(string: "https://en.m.wikipedia.org/wiki/\(cityName)")
    }

    init(guessHistory: CityGuessHistory) {
        self.city = TeleportCity(name: guessHistory.name)
        self.guessHistory = guessHistory
    }

    func fetchScores() async {
        if let fetchedScores = try? await TeleportApiClient().fetchScores(for: city) {
            DispatchQueue.main.async {
                self.cityScores = fetchedScores
            }
        }
    }
}
