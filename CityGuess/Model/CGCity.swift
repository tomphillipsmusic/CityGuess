//
//  CGCity.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/10/23.
//

import Foundation

struct CGCity: City, Identifiable, Codable {
    var name: String
    var href: String
    var continent: Continent
    var id: String { href }

    enum Continent: String, Codable, CaseIterable {
        case all = "All"
        case oceania = "Oceania"
        case southAmerica = "South America"
        case africa = "Africa"
        case asia = "Asia"
        case europe = "Europe"
        case northAmerica = "North America"
    }
}

extension CGCity {
    init?(name: String, href: String, continent: TeleportContinent) {
        guard let continent = Continent(rawValue: continent.name) else { return nil }

        self.name = name
        self.href = href
        self.continent = continent
    }
}
