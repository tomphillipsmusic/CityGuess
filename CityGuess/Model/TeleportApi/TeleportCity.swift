//
//  TeleportCity.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

struct TeleportCity: Codable, City, Identifiable {
    let href: String
    let name: String
    var id: String { href }

    init(href: String, name: String) {
        self.href = href
        self.name = name
    }

    init(name: String) {
        self.name = name
        let dashSeparatedName = name.replacingOccurrences(of: " ", with: "-")
        self.href = "https://api.teleport.org/api/urban_areas/slug:\(dashSeparatedName.lowercased())/"
    }
}

extension TeleportCity {

}
