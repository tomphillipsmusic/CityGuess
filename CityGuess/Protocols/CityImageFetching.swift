//
//  CityImageFetching.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

protocol CityImageFetching {
    func fetchCityImages() async throws -> [CityImage]
}
