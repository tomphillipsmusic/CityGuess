//
//  TeleportContinentsResponse.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/4/23.
//

import Foundation

// swiftlint:disable nesting
struct TeleportContinentsResponse: Codable {
    let links: Items

    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }

    struct Items: Codable {
        let continents: [TeleportContinent]

        enum CodingKeys: String, CodingKey {
            case continents = "continent:items"
        }
    }

    struct CitiesResponse: Codable {
        let count: Int
        let links: Links

        enum CodingKeys: String, CodingKey {
            case links = "_links"
            case count
        }

        struct Links: Codable {
            let cities: [TeleportCity]

            // swiftlint:disable nesting
            enum CodingKeys: String, CodingKey {
                case cities = "ua:items"
            }
        }
    }
}
