//
//  OnboardingToolbarButton.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/6/23.
//

import SwiftUI

struct OnboardingToolbarButton: View {
    @Binding var isShowingInfoSheet: Bool
    var body: some View {
        Button {
            isShowingInfoSheet = true
        } label: {
            Image(systemName: "questionmark.circle.fill")
        }
    }
}

struct OnboardingToolbarButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingToolbarButton(isShowingInfoSheet: .constant(true))
    }
}
