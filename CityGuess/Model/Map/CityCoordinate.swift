//
//  CityCoordinate.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import Foundation

struct CityCoordinate: City, Coordinate {
    let name: String
    let latitude: CGFloat
    let longitude: CGFloat
    var id = UUID()
}
