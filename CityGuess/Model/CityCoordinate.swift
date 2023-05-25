//
//  CityCoordinate.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import MapKit

struct CityCoordinate: City, Coordinate {
    let name: String
    let latitude: CGFloat
    let longitude: CGFloat
    var id = UUID()
}

extension CityCoordinate {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
