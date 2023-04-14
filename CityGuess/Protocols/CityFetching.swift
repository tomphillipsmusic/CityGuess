//
//  CityFetching.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

protocol CityFetching {
    associatedtype CityModel: City
    func fetchCities() async throws -> [CityModel]
}
