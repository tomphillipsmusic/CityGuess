//
//  TeleportCitiesResponse.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

struct TeleportCitiesResponse: Codable {
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
            case cities = "ua:item"
        }
    }
}
