//
//  View+Extension.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/28/23.
//

import SwiftUI

struct LargeTextScrollView: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    let maxSizeBeforeScroll: ContentSizeCategory
    let axis: Axis.Set

    func body(content: Content) -> some View {
        if sizeCategory > maxSizeBeforeScroll {
            ScrollView(axis) {
                content
            }
        } else {
            content
        }
    }
}

extension View {
    func largeTextScrollView(
        whenBiggerThan maxSizeBeforeScroll: ContentSizeCategory = .large,
        withAxis axis: Axis.Set = .vertical
    ) -> some View {
        modifier(LargeTextScrollView(maxSizeBeforeScroll: maxSizeBeforeScroll, axis: axis))
    }
}
