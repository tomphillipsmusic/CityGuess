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

    let fileHandler: ReadWrite

    init(service: ReadWrite = JsonService()) {
        self.fileHandler = service
    }

    func loadImages() throws -> [CityImage] {
        try fileHandler.read(from: Self.imagesFile)
    }

    func loadCities<T: City>() throws -> [T] where T: Decodable {
        try fileHandler.read(from: Self.citiesFile)
    }

    func save(_ images: [CityImage]) {
        fileHandler.write(images, to: Self.imagesFile)
    }

    func save<T: City>(_ cities: [T]) throws where T: City, T: Encodable {
        fileHandler.write(cities, to: Self.citiesFile)
    }    
}
