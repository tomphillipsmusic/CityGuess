//
//  CityService.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

protocol CityService {
    func loadCities<T: City>() throws -> [T] where T: Decodable
    func save<T: City>(_ cities: [T]) throws where T: Encodable
    func loadImages() throws -> [CityImage]
    func save(_ images: [CityImage])
}
