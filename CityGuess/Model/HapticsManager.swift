//
//  HapticsManager.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/25/23.
//

import SwiftUI

class HapticsManager {
    static let shared = HapticsManager()
    private var generator = UINotificationFeedbackGenerator()

    func correct() {
        generator.notificationOccurred(.success)
    }

    func incorrect() {
        generator.notificationOccurred(.error)
    }
}
