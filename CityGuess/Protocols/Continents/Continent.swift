//
//  Continent.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/3/23.
//

import Foundation

protocol Continent {
    associatedtype CityModel: City
    
    var name: String { get }
    var cities: [CityModel] { get set }
}
