//
//  Continent.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

struct Continent<CityModel: City>: Codable {
    let name: String
    let cities: [CityModel]
}
