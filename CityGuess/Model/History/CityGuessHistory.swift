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
}
