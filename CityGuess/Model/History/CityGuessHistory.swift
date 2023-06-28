//
//  CityGuessHistory.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/19/23.
//

import Foundation

struct CityGuessHistory: Identifiable, Codable {
    var id = UUID()
    let name: String
    var guessStatus: CityGuessStatus = .notSeen
    var timesSeen = 0
    var timesGuessedCorrectly = 0
}

#if DEBUG
extension CityGuessHistory {
    static let testData = [
        "New Detroit": CityGuessHistory(name: "New Detroit", guessStatus: .right),
        "New York": CityGuessHistory(name: "New York", guessStatus: .right),
        "New Orleans": CityGuessHistory(name: "New Orleans", guessStatus: .wrong)
    ]
}
#endif
