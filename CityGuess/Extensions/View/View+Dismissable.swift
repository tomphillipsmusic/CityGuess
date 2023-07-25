//
//  View+Dismissable.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import SwiftUI

struct Dismissable: ViewModifier {
    @Environment(\.dismiss) var dismiss

    func body(content: Content) -> some View {
        VStack {
            HStack {
                Spacer()

                Button("Close") {
                    dismiss()
                }
                .padding()
            }

            content
        }
    }
}

extension View {
    func dismissable() -> some View {
        modifier(Dismissable())
    }
}
