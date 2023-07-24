//
//  TeleportCityScore.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import Foundation

struct CityScore: Codable {
    let name: String
    let scoreOutOf10: Double

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CityScore.CodingKeys> = try decoder.container(keyedBy: CityScore.CodingKeys.self)
        self.name = try container.decode(String.self, forKey: CityScore.CodingKeys.name)
        self.scoreOutOf10 = try container.decode(Double.self, forKey: CityScore.CodingKeys.scoreOutOf10)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case scoreOutOf10 = "score_out_of_10"
    }
}
