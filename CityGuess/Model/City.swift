//
//  City.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

struct City: Codable, Identifiable {
    let country: String
    let name: String
    let lat: String
    let lng: String
    
    var id: String {
        country + name + lat + lng
    }
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.name == rhs.name
    }
}
