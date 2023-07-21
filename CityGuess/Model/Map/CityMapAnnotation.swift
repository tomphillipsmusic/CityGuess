//
//  CityMapAnnotation.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/13/23.
//

import MapKit

class CityMapAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let history: CityGuessHistory

    var url: URL? {
        guard var title else { return nil }

        if title.contains(" ") {
            title = title.replacingOccurrences(of: " ", with: "_")
        }

        return URL(string: "https://en.m.wikipedia.org/wiki/\(title)")
    }

    init(cityCoordinate: CityCoordinate, history: CityGuessHistory) {
        self.coordinate = cityCoordinate.clLocationCoordinate2D
        self.title = cityCoordinate.name
        self.history = history
        self.subtitle = "Successfully guessed \(history.timesGuessedCorrectly) / \(history.timesSeen) times"
    }
}
