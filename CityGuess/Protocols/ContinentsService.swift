//
//  ContinentsService.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

protocol ContinentsService {
    associatedtype CityModel: City

    func fetchContinents() async throws -> [Continent<CityModel>]
    func save(_ continents: [Continent<CityModel>])
    func loadContinents() throws -> [Continent<CityModel>]
}
