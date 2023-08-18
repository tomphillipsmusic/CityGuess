//
//  CGContinent.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/11/23.
//

import Foundation

enum CGContinent: String, Codable, CaseIterable {
    case all = "All"
    case oceania = "Oceania"
    case southAmerica = "South America"
    case africa = "Africa"
    case asia = "Asia"
    case europe = "Europe"
    case northAmerica = "North America"
}

import MapKit

extension CGContinent {
    var geographicCenter: CLLocationCoordinate2D {
        switch self {
        case .all:
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case .oceania:
            return CLLocationCoordinate2D(latitude: -22.7359, longitude: 140.0188)
        case .southAmerica:
            return CLLocationCoordinate2D(latitude: -8.7832, longitude: -55.4915)
        case .africa:
            return CLLocationCoordinate2D(latitude: -8.7832, longitude: 34.5085)
        case .asia:
            return CLLocationCoordinate2D(latitude: 34.0479, longitude: 100.6197)
        case .europe:
            return CLLocationCoordinate2D(latitude: 54.5260, longitude: 15.2551)
        case .northAmerica:
            return CLLocationCoordinate2D(latitude: 54.5260, longitude: -105.2551)
        }
    }
}
