//
//  CoordinateFetching.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import Foundation

protocol CoordinateFetching {
    associatedtype CityModel = City
    associatedtype CityCoordinateModel = City & Coordinate

    func fetchCoordinates(for cities: [CityModel]) async throws -> [CityCoordinateModel]
    func fetchCoordinates(for city: CityModel) async throws -> CityCoordinateModel
}
