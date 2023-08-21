//
//  City.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/22/23.
//

import Foundation

protocol City: Codable, Hashable {
    var name: String { get }
}
