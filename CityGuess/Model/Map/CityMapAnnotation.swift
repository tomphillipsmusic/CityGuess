//
//  CityMapAnnotation.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/13/23.
//

import MapKit

extension CityCoordinate {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class CityMapAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let status: CityGuessStatus

    init(cityCoordinate: CityCoordinate, status: CityGuessStatus) {
        self.coordinate = cityCoordinate.clLocationCoordinate2D
        self.title = cityCoordinate.name
        self.status = status
    }
}
