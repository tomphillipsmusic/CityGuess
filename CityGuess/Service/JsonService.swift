//
//  JsonService.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

struct JsonService {
    func write<T: Codable>(_ data: T, to filename: String) -> Void {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(filename)

            try JSONEncoder().encode(data)
                .write(to: filePath)
            
        } catch (let error) {
            print(error)
        }
    }
    
    func read<T: Codable> (from filename: String) -> T? {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(filename)
            
            let data = try Data(contentsOf: filePath)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
