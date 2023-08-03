//
//  ContinentFetching.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

protocol ContinentFetching {
    associatedtype CityModel: City

    func fetchContinents() async throws -> [Continent<CityModel>]
    func fetchCities(for continent: Continent<CityModel>) async throws -> [CityModel]
}
