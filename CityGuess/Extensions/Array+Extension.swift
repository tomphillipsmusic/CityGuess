//
//  Array+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

extension Array {
    func prefix(upToIfPossible index: Int) -> [Element] {
        var maxIndex = index
        
        if index > count {
           maxIndex = count
        }
        
        return Array(prefix(upTo: maxIndex))
    }
}
