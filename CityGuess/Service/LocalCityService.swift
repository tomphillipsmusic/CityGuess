//
//  JsonService.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

struct LocalCityService: CityService {
    static private let citiesFile = "cities.json"
    static private let imagesFile = "images.json"

    let service: ReadWrite

    init(service: ReadWrite = JsonService()) {
        self.service = service
    }

    func loadImages() throws -> [CityImage] {
        try service.read(from: Self.imagesFile)
    }

    func loadCities<T: City>() throws -> [T] where T: Decodable {
        try service.read(from: Self.citiesFile)
    }

    func save(_ images: [CityImage]) {
        service.write(images, to: Self.imagesFile)
    }

    func save<T: City>(_ cities: [T]) throws where T: City, T: Encodable {
        service.write(cities, to: Self.citiesFile)
    }
}
