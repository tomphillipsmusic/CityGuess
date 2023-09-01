//
//  Unlockable.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/23/23.
//

import Foundation

protocol Unlockable {
    var isLocked: Bool { get }
    var unlockTime: TimeInterval { get set }
    var unlockText: String { get }
    func calculateUnlockProgress()
}
