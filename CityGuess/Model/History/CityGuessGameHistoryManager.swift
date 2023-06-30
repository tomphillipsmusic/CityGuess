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
    let historyService: ReadWrite

    static let cityGuessHistoryFilename = "city-guess-history"

    var totalCitiesSeen: Int {
        guessHistory.values.filter { $0.guessStatus != .notSeen }.count
    }

    var citiesGuessedCorrectly: Int {
        guessHistory.values.filter { $0.guessStatus == .right }.count
    }

    init(historyService: ReadWrite = JsonService()) {
        self.historyService = historyService

        if let savedHistory = try? loadHistory() {
            guessHistory = savedHistory
        }
    }

    func updateHistory(forCityNamed cityName: String, with status: CityGuessStatus) {
        if guessHistory[cityName] != nil {
            let hasAlreadyBeenGuessedCorrectly = guessHistory[cityName]?.guessStatus == .right

            // Make sure that cities that have been guessed right before stay right
            if !hasAlreadyBeenGuessedCorrectly {
                guessHistory[cityName]?.guessStatus = status
            }

        } else {
            guessHistory[cityName] = CityGuessHistory(name: cityName)
            guessHistory[cityName]?.guessStatus = status
        }

        if status == .right {
            guessHistory[cityName]?.timesGuessedCorrectly += 1
        }

        guessHistory[cityName]?.timesSeen += 1
        saveHistory()
    }

    func saveHistory() {
        historyService.write(guessHistory, to: Self.cityGuessHistoryFilename)
    }

    func loadHistory() throws -> CityGuessHistoryDictionary {
        try historyService.read(from: Self.cityGuessHistoryFilename)
    }
}
