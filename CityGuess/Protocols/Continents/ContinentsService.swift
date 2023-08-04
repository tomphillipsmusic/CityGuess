//
//  ContinentsService.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

protocol ContinentsService {
    associatedtype CityModel: City
    associatedtype ContinentModel: Continent where ContinentModel.CityModel == CityModel

    func fetchContinents() async throws -> [ContinentModel]
    func save(_ continents: [ContinentModel])
    func loadContinents() throws -> [ContinentModel]
}
