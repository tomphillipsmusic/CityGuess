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

    var body: some View {
        VStack {
            VStack {
                Text("Welcome to City Guess!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()
                    .accessibilityLabel(Text("Welcome to City Guess!"))

                Image(systemName: "building.2")
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 5)
                    .padding(.horizontal, 60)

                Text("""
                     A fun game to test how well you can recognize photos of cities from all
                     over the world! Can you correctly guess all of the cities and become a
                     true city guesser?
                    """)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()

                VStack(alignment: .leading) {
                    OnboardingDetailRow(
                        symbol: "medal",
                        text: "The daily challenge will test you with new photos every single day",
                        color: .green
                    )
                    OnboardingDetailRow(
                        symbol: "figure.run",
                        text: "Train anytime to test your knowledge of all of the cities and discover new cities",
                        color: .green
                    )
                    OnboardingDetailRow(
                        symbol: "globe",
                        text: "Unlock all of the cities on the world map and track your progress as you play",
                        color: .green
                    )
                }
            }
            .accessibilityElement(children: .combine)

            MainMenuButton("Start Guessing!") {
                firstTime = false
                dismiss()
            }
        }
        .largeTextScrollView()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(firstTime: .constant(true))
    }
}
