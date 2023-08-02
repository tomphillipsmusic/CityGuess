//
//  CityGuessGameHistoryManager.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/19/23.
//

import SwiftUI

typealias CityGuessHistoryDictionary = [String: CityGuessHistory]

class CityGuessGameHistoryManager: ObservableObject {
    @AppStorage("totalNumberOfCities") var totalNumberOfCities: Int = 0
    @Published private(set) var guessHistory: CityGuessHistoryDictionary = [:]
    @Published var tempGuessHistory: CityGuessHistoryDictionary = [:]
    @Published var roundHistory = CityGuessHistoryDictionary()
    @Published private(set) var newCitiesSeen = 0
    @Published private(set) var newCitiesGuessedCorrectly = 0
    @Published var roundStartTotalCitiesSeen = 0
    @Published var roundStartTotalCitiesGuessedCorrectly = 0

    let historyService: ReadWrite

    static let cityGuessHistoryFilename = "city-guess-history"

    var totalCitiesSeen: Int {
        guessHistory.values.filter { $0.guessStatus != .notSeen }.count
    }

    var citiesGuessedCorrectly: Int {
        guessHistory.values.filter { $0.guessStatus == .right }.count
    }

    var newCitiesSeenLabel: String {
        "New Cities seen this round: \(newCitiesSeen)"
    }

    var newCitiesGuessedCorrectlyLabel: String {
        "New cities guessed correctly this round: \(newCitiesGuessedCorrectly)"
    }

    var totalCitiesSeenLabelText: String {
        "Total Cities Seen: \(totalCitiesSeen) / \(totalNumberOfCities)"
    }

    var totalCitiesGuessedCorrectlyText: String {
        "Cities Guessed Correctly: \(citiesGuessedCorrectly) / \(totalNumberOfCities)"
    }

    init(historyService: ReadWrite = JsonService()) {
        self.historyService = historyService

        if let savedHistory = try? loadHistory() {
            guessHistory = savedHistory
        }
    }

    func updateHistory(forImage cityImage: CityImage, with status: CityGuessStatus) {
        tempGuessHistory = guessHistory
        let cityName = cityImage.title
        roundHistory[cityName] = CityGuessHistory(name: cityName, guessStatus: status, urlString: cityImage.url)

        if tempGuessHistory[cityName] != nil {
            let hasAlreadyBeenGuessedCorrectly = tempGuessHistory[cityName]?.guessStatus == .right

            // Make sure that cities that have been guessed right before stay right
            if !hasAlreadyBeenGuessedCorrectly {
                tempGuessHistory[cityName]?.guessStatus = status
            }

        } else {
            tempGuessHistory[cityName] = CityGuessHistory(name: cityName, urlString: cityImage.url)
            tempGuessHistory[cityName]?.guessStatus = status
            updateRoundHistory(guessStatus: status)
        }

        if status == .right {
            tempGuessHistory[cityName]?.timesGuessedCorrectly += 1
        }

        tempGuessHistory[cityName]?.timesSeen += 1
    }

    func resetRoundHistory(withTotalNumberOfCities totalCitiesSeen: Int) {
        newCitiesSeen = 0
        newCitiesGuessedCorrectly = 0
        roundHistory = [:]
        roundStartTotalCitiesSeen = totalCitiesSeen
        roundStartTotalCitiesGuessedCorrectly = citiesGuessedCorrectly
        self.totalNumberOfCities = totalCitiesSeen
    }

    private func updateRoundHistory(guessStatus: CityGuessStatus) {
        if guessStatus == .right {
            newCitiesGuessedCorrectly += 1
        }

        newCitiesSeen += 1
    }

    func saveHistory() {
        guessHistory = tempGuessHistory
        historyService.write(guessHistory, to: Self.cityGuessHistoryFilename)
    }

    func loadHistory() throws -> CityGuessHistoryDictionary {
        try historyService.read(from: Self.cityGuessHistoryFilename)
    }
}

#if DEBUG
extension CityGuessGameHistoryManager {
    func update(_ key: String, with value: CityGuessHistory) {
        guessHistory[key] = value
    }

    func update(_ history: CityGuessHistoryDictionary) {
        guessHistory = history
    }
}
#endif
