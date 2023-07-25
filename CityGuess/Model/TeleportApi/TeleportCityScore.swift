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
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.scoreOutOf10 = try container.decode(Double.self, forKey: CodingKeys.scoreOutOf10)
    }

    init(name: String, scoreOutOf10: Double) {
        self.name = name
        self.scoreOutOf10 = scoreOutOf10
    }

    enum CodingKeys: String, CodingKey {
        case name
        case scoreOutOf10 = "score_out_of_10"
    }
}

#if DEBUG
extension CityScore {
    static let testData = Array(repeating: CityScore(name: "Weather", scoreOutOf10: Double(Int.random(in: 0...10))), count: 10)
}
#endif
