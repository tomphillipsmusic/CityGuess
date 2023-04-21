//
//  AutofillSuggestionsView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/18/23.
//

import SwiftUI

struct AutofillSuggestionsView<T: City>: View {
    let autofillSuggestions: [T]
    let action: (String) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(autofillSuggestions, id: \.name) { autofill in
                    let cityName = autofill.name

                    Button(cityName) {
                        action(cityName)
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
        AutofillSuggestionsView(autofillSuggestions: [TeleportCity(href: "", name: "Test")]) { _ in

        }
    }
}
