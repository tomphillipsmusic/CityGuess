//
//  CityGuessHistory.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/19/23.
//

import Foundation

struct CityGuessHistory: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let continent: CGCity.Continent
    var guessStatus: CityGuessStatus = .notSeen
    var timesSeen = 0
    var timesGuessedCorrectly = 0
    var urlString: String

    var label: String {
        "Successfully guessed \(timesGuessedCorrectly) / \(timesSeen) times"
    }
}

#if DEBUG
extension CityGuessHistory {
    static let testData = [
        "New Detroit": CityGuessHistory(
            name: "New Detroit",
            continent: .northAmerica,
            guessStatus: .wrong,
            urlString: "https://d13k13wj6adfdf.cloudfront.net/urban_areas/detroit-e0a9dfeff2.jpg"
        ),
        "New York": CityGuessHistory(
            name: "New York",
            continent: .northAmerica,
            guessStatus: .right,
            urlString: "https://d13k13wj6adfdf.cloudfront.net/urban_areas/detroit-e0a9dfeff2.jpg"),
        "New Orleans": CityGuessHistory(
            name: "New Orleans",
            continent: .northAmerica,
            guessStatus: .wrong,
            urlString: "https://d13k13wj6adfdf.cloudfront.net/urban_areas/detroit-e0a9dfeff2.jpg")
    ]
}
#endif
