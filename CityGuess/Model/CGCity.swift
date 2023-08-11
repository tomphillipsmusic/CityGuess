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
    var continent: CGContinent
    var id: String { href }
}

extension CGCity {
    init?(name: String, href: String, continent: TeleportContinent) {
        guard let continent = CGContinent(rawValue: continent.name) else { return nil }

        self.name = name
        self.href = href
        self.continent = continent
    }
}
