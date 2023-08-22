//
//  View+ScreenshotView.swift
//  CityGuess
//
//  Created by Tom Phillips on 8/22/23.
//

import SwiftUI

extension View {
    func screenshotView(_ closure: @escaping ScreenshotMakerClosure) -> some View {
        let screenshotView = ScreenshotMakerView(closure)
        return overlay(screenshotView.allowsHitTesting(false))
    }
}
