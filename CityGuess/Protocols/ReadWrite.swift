//
//  ReadWrite.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import Foundation

typealias ReadWrite = Read & Write

protocol Read {
    func read<T: Decodable> (from filename: String) -> T?
}

protocol Write {
    func write<T: Encodable>(_ data: T, to filename: String) -> Void
}
