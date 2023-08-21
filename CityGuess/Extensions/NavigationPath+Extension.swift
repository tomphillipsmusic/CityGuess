//
//  NavigationPath+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/21/23.
//

import SwiftUI

extension NavigationPath {
    mutating func removeAll() {
        while !self.isEmpty {
            self.removeLast()
        }
    }
}
