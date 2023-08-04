//
//  Sequence+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/11/23.
//

import Foundation

extension Sequence {
    func filterUniqueItems(_ isIncluded: (Self.Element) -> Bool, limit: Int) -> [Self.Element] where Element: Hashable {
        var filteredCount = 0
        var results: Set<Self.Element> = []
        results.reserveCapacity(limit)
        var iterator = self.makeIterator()

        while filteredCount < limit, let element = iterator.next() {
            if isIncluded(element), !results.contains(where: { $0 == element }) {
                filteredCount += 1
                results.insert(element)
            }
        }

        return Array(results)
    }

    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
