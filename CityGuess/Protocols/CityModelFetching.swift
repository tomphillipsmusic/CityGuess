//
//  CityFetching.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

typealias CityFetching = CityModelFetching & CityImageFetching

protocol CityModelFetching {
    associatedtype CityModel: City
    func fetchCities() async throws -> [CityModel]
}

protocol CityImageFetching {
    func fetchCityImages() async throws -> [CityImage]
}
