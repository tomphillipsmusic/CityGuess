//
//  URL+Identifiable.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/21/23.
//

import Foundation

extension URL: Identifiable {
    public var id: String { self.absoluteString }
}
