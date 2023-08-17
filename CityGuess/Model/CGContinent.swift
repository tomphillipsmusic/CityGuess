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
// Get geographic coordinate centers for each continent so tapping the progress bar moves the map to that continent on the map
extension CGContinent {
    var geographicCenter: CLLocationCoordinate2D {
        switch self {
        case .all:
            CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case .oceania:
            CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case .southAmerica:
            CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case .africa:
            CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case .asia:
            CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case .europe:
            CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case .northAmerica:
            CLLocationCoordinate2D(latitude: 48, longitude: -10)
           // 48°10′N 100°10′W
        }
        
        return CLLocationCoordinate2D(latitude: 48, longitude: -10)
    }
}
