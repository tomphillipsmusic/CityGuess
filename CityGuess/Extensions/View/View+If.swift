//
//  View+If.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/25/23.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
