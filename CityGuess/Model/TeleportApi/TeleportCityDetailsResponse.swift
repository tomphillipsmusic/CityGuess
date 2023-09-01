//
//  TeleportCityDetailsResponse.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import Foundation

struct TeleportCityDetailsResponse: Codable {
    let boundingBox: BoundingBox

    enum CodingKeys: String, CodingKey {
        case boundingBox = "bounding_box"
    }

    struct BoundingBox: Codable {
        let latlon: CoordinateBox
    }
}
