//
//  Continent.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

struct TeleportContinent: Continent {
    let name: String
    var cities: [TeleportCity] = []
}

extension TeleportContinent: Codable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<TeleportContinent.CodingKeys> = try decoder.container(keyedBy: TeleportContinent.CodingKeys.self)
        self.name = try container.decode(String.self, forKey: TeleportContinent.CodingKeys.name)
        self.cities = []
    }
}
