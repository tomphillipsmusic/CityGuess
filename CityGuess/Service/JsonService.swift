//
//  JsonService.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

protocol CityService {
    func loadCities() -> [City]
}

struct JsonCityService: CityService {
    static private let filename = "cities.json"
    
    func loadCities() -> [City] {
        Bundle.main.decode([City].self, from: Self.filename).sorted(by: { $0.name < $1.name})
    }
}
