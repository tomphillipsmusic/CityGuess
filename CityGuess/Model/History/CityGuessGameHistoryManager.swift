//
//  CityGuessGameHistoryManager.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/19/23.
//

import Foundation

typealias CityGuessHistoryDictionary = [String: CityGuessHistory]

class CityGuessGameHistoryManager: ObservableObject {
    @Published var guessHistory: CityGuessHistoryDictionary = [:]

    static let cityGuessHistoryFilename = "city-guess-history"

    init() {
        if let savedHistory = try? loadHistory() {
            guessHistory = savedHistory
        }
    }

    func updateHistory(forCityNamed cityName: String, with status: CityGuessStatus) {
        if guessHistory[cityName] != nil {

            // Make sure that cities that have been guessed right before stay right
            if guessHistory[cityName]?.guessStatus != .right {
                guessHistory[cityName]?.guessStatus = status
            } else {
                guessHistory[cityName]?.timesGuessedCorrectly += 1
            }
        } else {
            guessHistory[cityName] = CityGuessHistory(name: cityName)
            guessHistory[cityName]?.guessStatus = status
        }

        guessHistory[cityName]?.timesSeen += 1
        saveHistory()
    }

    func saveHistory() {
        JsonService().write(guessHistory, to: Self.cityGuessHistoryFilename)
    }

    func loadHistory() throws -> CityGuessHistoryDictionary {
        try JsonService().read(from: Self.cityGuessHistoryFilename)
    }
}
