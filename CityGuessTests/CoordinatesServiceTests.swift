//
//  CoordinatesServiceTests.swift
//  CityGuessTests
//
//  Created by Tom Phillips on 5/24/23.
//

import XCTest
@testable import CityGuess

enum MockCity: City, CaseIterable {
    case detroit, london, sydney, saoPaulo, fakeCity, madeUpMetropolis

    var name: String {
        switch self {
        case .detroit:
            return "Detroit"
        case .london:
            return "London"
        case .sydney:
            return "Sydney"
        case .saoPaulo:
            return "Sao Paulo"
        case .fakeCity:
            return "Fake City"
        case .madeUpMetropolis:
            return "Made Up Metropolis"
        }
    }

    var coordinateBox: CoordinateBox {
        switch self {
        case .detroit:
            return CoordinateBox(east: -82.375, north: 43.168, west: -84.158, south: 41.723)
        case .london:
            return CoordinateBox(east: 0.5933, north: 51.795, west: -0.9531, south: 51.1776)
        case .sydney:
            return CoordinateBox(east: 151.647, north: -33.637, west: 150.628, south: -34.189)
        case .saoPaulo:
            return CoordinateBox(east: -45.863, north: -23.125, west: -47.357, south: -24.317)
        case .fakeCity:
            return CoordinateBox(east: 0.5, north: 0.5, west: -0.5, south: -0.5)
        case .madeUpMetropolis:
            return CoordinateBox(east: 0, north: 0, west: -0.5, south: -0.5)
        }

    }

    var coordinate: CityCoordinate {
        switch self {
        case .detroit:
            return CityCoordinate(name: name, latitude: 42.445499999999996, longitude: -83.26650000000001)
        case .london:
            return CityCoordinate(name: name, latitude: 51.4863, longitude: -0.17989999999999995)
        case .sydney:
            return CityCoordinate(name: name, latitude: -33.913, longitude: 151.1375)
        case .saoPaulo:
            return CityCoordinate(name: name, latitude: -23.721, longitude: -46.61)
        case .fakeCity:
            return CityCoordinate(name: name, latitude: 0, longitude: 0)
        case .madeUpMetropolis:
            return CityCoordinate(name: name, latitude: -0.25, longitude: -0.25)
        }
    }
}

final class CoordinatesServiceTests: XCTestCase {
    let coordinatesService = TeleportCoordinatesService()

    func testCalculateCoordinates() throws {
        // Arrange
        let mockCities = MockCity.allCases

        // Act
        let coordinates = mockCities.map {
            coordinatesService.calculateCoordinates(from: $0.coordinateBox, named: $0.name)
        }

        // Assert

        for index in 0..<mockCities.count {
            let actualCoordinate = coordinates[index]
            let expectedCoordinate = mockCities[index].coordinate

            XCTAssertEqual(expectedCoordinate, actualCoordinate)
        }
    }
}
