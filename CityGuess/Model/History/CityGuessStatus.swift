//
//  CityGuessStatus.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/19/23.
//

import SwiftUI

enum CityGuessStatus: Codable {
    case wrong, right, notSeen

    var color: Color {
        switch self {
        case .wrong:
            return .red
        case .right:
            return .green
        case .notSeen:
            return .gray
        }
    }
}
