//
//  String+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/26/23.
//

import Foundation

extension String {
    func caseInsensitiveStarts(with string: String) -> Bool {
        self.lowercased().starts(with: string.lowercased())
    }

    func caseInsensitiveContains(_ other: String) -> Bool {
        self.lowercased().contains(other.lowercased())
    }
}
