//
//  Bundle+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

extension Bundle {

    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {

        guard let url = self.url(forResource: file, withExtension: nil) else {
            print("Failed to locate \(file) in bundle.")
            throw URLError(.fileDoesNotExist)
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' \(context.debugDescription)")
            throw DecodingError.keyNotFound(key, context)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
            throw DecodingError.typeMismatch(type, context)
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
            throw DecodingError.valueNotFound(type, context)
        } catch DecodingError.dataCorrupted(let context) {
            print("Failed to decode \(file) from bundle because it appears to be invalid JSON")
            throw DecodingError.dataCorrupted(context)
        } catch {
            print("Failed to decode \(file) from bundle: \(error.localizedDescription)")
            throw error
        }
    }
}
