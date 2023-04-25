//
//  AnimationType.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/25/23.
//

import Foundation

enum AnimationType: String {
    case correct, incorrect

    var name: String { rawValue }

    var initialOffset: CGFloat {
        switch self {
        case .correct:
            return -150
        case .incorrect:
            return 150
        }
    }

    var endingOffset: TimeInterval {
        switch self {
        case .correct:
            return -100
        case .incorrect:
            return 100
        }
    }

    var length: CGFloat {
        switch self {
        case .correct:
            return 3.0
        case .incorrect:
            return 1.5
        }
    }

    var speedMultiplier: Double {
        switch self {
        case .correct:
            return 1.45
        default:
            return 1.0
        }
    }

}
