//
//  ContinentFetching.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

protocol ContinentFetching {
    associatedtype CityModel: City
    associatedtype ContinentModel: Continent where ContinentModel.CityModel == CityModel

    func fetchContinents() async throws -> [ContinentModel]
    func fetchCities(for continent: ContinentModel) async throws -> [CityModel]
}
