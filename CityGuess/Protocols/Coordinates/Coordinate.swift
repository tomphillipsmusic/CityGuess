//
//  Coordinate.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import Foundation

protocol Coordinate: Identifiable {
    var latitude: CGFloat { get }
    var longitude: CGFloat { get }
    var id: UUID { get set }
}
