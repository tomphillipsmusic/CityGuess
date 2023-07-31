//
//  OnboardingView.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/28/23.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var firstTime: Bool
    @Environment(\.dismiss) var dismiss
    let onboarding: Onboarding

    var body: some View {
        VStack {
            VStack {
                Text(onboarding.title)
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()
                    .accessibilityLabel(Text(onboarding.title))

                onboarding.image
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 5)
                    .padding(.horizontal, 60)

                Text(onboarding.description)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()

                VStack(alignment: .leading) {
                    ForEach(onboarding.details) { detail in
                        OnboardingDetailRow(symbol: detail.symbol, text: detail.text, color: detail.color)
                    }
                }
            }
            .accessibilityElement(children: .combine)

            MainMenuButton(onboarding.closeButtonLabel) {
                firstTime = false
                dismiss()
            }
        }
        .largeTextScrollView()
        .dismissable()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(firstTime: .constant(true), onboarding: Onboarding.cityGuessOnboarding)
    }
}
