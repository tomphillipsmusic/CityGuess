//
//  CoordinatesService.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import Foundation

protocol CoordinatesService: CoordinateFetching {
    associatedtype CityCoordinateModel = City & Coordinate & Codable

    func save(_ coordinates: [CityCoordinateModel])
    func loadCoordinates() throws -> [CityCoordinateModel]
}
