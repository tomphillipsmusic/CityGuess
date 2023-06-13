//
//  CoordinatesProtocol.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/23/23.
//

import Foundation

actor TeleportCoordinatesService: CoordinatesService {
    let coordinatesFile = "coordinates.json"

    let client = TeleportApiClient()
    let fileHandler = JsonService()

    func fetchCoordinates(for cities: [TeleportCity]) async throws -> [CityCoordinate] {
        var coordinates: [CityCoordinate] = []

        if let savedCoordinates = try? loadCoordinates(),
            savedCoordinates.count != cities.count {
            coordinates = savedCoordinates
        } else {
            for city in cities {
                let coordinateBox = try await client.fetchCoordinateBox(for: city)
                let coordinate = calculateCoordinates(from: coordinateBox, named: city.name)
                coordinates.append(coordinate)
            }

            save(coordinates)
        }

        return coordinates
    }

    func calculateCoordinates(
        from coordinateBox: CoordinateBox,
        named name: String) -> CityCoordinate {
        let distanceFromNorthSouth = coordinateBox.north - coordinateBox.south
        let distanceFromEastWest = coordinateBox.east - coordinateBox.west

        let latitude = coordinateBox.south + (distanceFromNorthSouth / 2.0)
        let longitude = coordinateBox.west + (distanceFromEastWest / 2.0)

        return CityCoordinate(name: name, latitude: latitude, longitude: longitude)
    }

    nonisolated func save(_ coordinates: [CityCoordinate]) {
        fileHandler.write(coordinates, to: coordinatesFile)
    }

    nonisolated func loadCoordinates() throws -> [CityCoordinate] {
        try fileHandler.read(from: coordinatesFile)
    }
}
