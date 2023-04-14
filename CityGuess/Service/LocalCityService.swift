//
//  JsonService.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

struct LocalCityService: CityService {
    let jsonService = JsonService()
    
    func save<T: City>(_ cities: [T]) throws where T : City, T : Encodable {
        write(cities)
    }
    
    static private let filename = "cities.json"
    
    func loadCities<T: City>() throws -> [T] where T: Decodable {
        do {
            return try Bundle.main.decode([T].self, from: Self.filename).sorted(by: { $0.name < $1.name})
        }
    }
    
    func write<T: Codable>(_ data: T) -> Void {
        jsonService.write(data, to: Self.filename)
    }
    
    func read<T: Codable> () -> T? {
        jsonService.read(from: Self.filename)
    }
}
