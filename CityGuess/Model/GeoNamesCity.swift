//
//  City.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

protocol City: Codable, Hashable {
    var name: String { get }
}

struct GeoNamesCity: Codable, Identifiable, City {
    let country: String
    let name: String
    let lat: String
    let lng: String

    var id: String {
        country + name + lat + lng
    }
}
