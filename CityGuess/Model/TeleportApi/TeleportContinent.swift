//
//  Continent.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

struct TeleportContinent: Continent {
    let name: String
    let href: String
    var cities: [TeleportCity] = []
}

extension TeleportContinent: Codable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.href = try container.decode(String.self, forKey: .href)
        self.cities = []
    }
}
