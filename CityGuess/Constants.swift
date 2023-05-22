//
//  Constants.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/22/23.
//

import Foundation

enum DateConstants {
    static let secondsInAMinute: Double = 60
    static let minutesInAnHour: Double = 60
    static let hoursinADay: Double = 24
    static let unlockInterval: Double = Self.secondsInAMinute * Self.minutesInAnHour * Self.hoursinADay
}
