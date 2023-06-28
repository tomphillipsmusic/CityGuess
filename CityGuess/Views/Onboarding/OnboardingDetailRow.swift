//
//  OnboardingDetailRow.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/28/23.
//

import SwiftUI

struct OnboardingDetailRow: View {
    let symbol: String
    let text: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .resizable()
                .scaledToFit()
                .frame(width: 32)
                .scaledToFit()
                .padding()
                .foregroundColor(color)

            Text(text)
                .font(.body)
                .padding(.trailing)
        }
    }
}
