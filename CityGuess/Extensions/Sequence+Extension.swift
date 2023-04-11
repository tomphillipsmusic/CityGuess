//
//  Sequence+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/11/23.
//

import Foundation

extension Sequence {
    func filter(_ isIncluded: (Self.Element) -> Bool, limit: Int) -> [Self.Element] {
        var filteredCount = 0
        var results: [Self.Element] = []
        results.reserveCapacity(limit)
        var iterator = self.makeIterator()
        
        while filteredCount < limit, let element = iterator.next() {
            if isIncluded(element) {
                filteredCount += 1
                results.append(element)
            }
        }
        
        return results
    }
}
