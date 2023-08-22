//
//  AutofillSuggestionsView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/18/23.
//

import SwiftUI

struct AutofillSuggestionsView: View {
    let autofillSuggestions: [CGCity]
    let action: (CGCity) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(autofillSuggestions, id: \.name) { city in
                    let cityName = city.name

                    Button(cityName) {
                        action(city)
                    }
                    .padding()
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

struct AutofillSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        AutofillSuggestionsView(autofillSuggestions: [CGCity(name: "Test", href: "", continent: .africa)]) { _ in
        }
    }
}
