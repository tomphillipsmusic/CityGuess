//
//  JsonService.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

protocol CityService {
    func loadCities<T: City>() throws -> [T] where T: Decodable
    func save<T: City>(_ cities: [T]) throws where T: Encodable
}

struct JsonCityService: CityService {
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
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(Self.filename)

            try JSONEncoder().encode(data)
                .write(to: filePath)
            
        } catch (let error) {
            print(error)
        }
    }
    
    func read<T: Codable> () -> T? {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(Self.filename)
            
            let data = try Data(contentsOf: filePath)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
