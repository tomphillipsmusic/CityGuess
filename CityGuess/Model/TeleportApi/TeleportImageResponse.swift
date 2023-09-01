//
//  TeleportImageResponse.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

struct TeleportImageResponse: Codable {
    let photos: [Photo]

    struct Photo: Codable {
        let image: Image

    }

    struct Image: Codable {
        let mobile: String
    }
}
