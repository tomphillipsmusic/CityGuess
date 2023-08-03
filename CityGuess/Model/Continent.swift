//
//  Continent.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

struct Continent<CityModel: City> {
    let name: String
    var cities: [CityModel] = []
}

extension Continent: Codable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Continent<CityModel>.CodingKeys> = try decoder.container(keyedBy: Continent<CityModel>.CodingKeys.self)
        self.name = try container.decode(String.self, forKey: Continent<CityModel>.CodingKeys.name)
        self.cities = []
    }
}
