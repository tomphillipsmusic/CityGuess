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
}
