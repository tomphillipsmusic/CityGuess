//
//  TeleportContinentService.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

class TeleportContinentService: ContinentsService {
    typealias CityModel = TeleportCity
    typealias ContinentModel = TeleportContinent

    let coordinatesFile = "continents.json"

    let client = TeleportApiClient()
    let fileHandler = JsonService()

    func fetchContinents() async throws -> [TeleportContinent] {
        var continents: [TeleportContinent] = []

        if let savedContinents = try? loadContinents() {
            continents = savedContinents
        } else {
             continents = try await client.fetchContinents()

            continents = try await continents.asyncMap { continent in
                let cities = try await client.fetchCities(for: continent)
                return TeleportContinent(name: continent.name, href: continent.href, cities: cities)
            }

            save(continents)
        }

        return continents
    }

    func save(_ coordinates: [TeleportContinent]) {
        fileHandler.write(coordinates, to: coordinatesFile)
    }

    func loadContinents() throws -> [TeleportContinent] {
        try fileHandler.read(from: coordinatesFile)
    }
}
