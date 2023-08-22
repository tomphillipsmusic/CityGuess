//
//  Date+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/21/23.
//

import Foundation

extension Date {
    var startOfNextDay: Date? {
        let startOfNextDay = Calendar.current.nextDate(
            after: self,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTimePreservingSmallerComponents
        )

        return startOfNextDay
    }

    var secondsUntilNextDay: TimeInterval? {
        let startOfNextDay = startOfNextDay
        let timeInterval = startOfNextDay?.timeIntervalSince(self)
        return timeInterval
    }
}
