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

//extension City where Self: Equatable {
//    func isEqual(to other: City) -> Bool {
//        guard let otherCity = other as? Self else { return false }
//
//        return self == otherCity
//    }
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.name == rhs.name
//    }
//}

struct GeoNamesCity: Codable, Identifiable, City {
    let country: String
    let name: String
    let lat: String
    let lng: String
    
    var id: String {
        country + name + lat + lng
    }
}

//extension GeoNamesCity: Equatable {
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.isEqual(to: rhs)
//    }
//}
