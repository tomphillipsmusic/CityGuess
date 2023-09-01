//
//  TeleportCityScoreResponse.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import Foundation

struct TeleportCityScoresResponse: Codable {
    let categories: [CityScore]
}
