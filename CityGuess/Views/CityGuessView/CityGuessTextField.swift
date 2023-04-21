//
//  CityGuessTextField.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/18/23.
//

import SwiftUI

struct CityGuessTextField: View {
    @FocusState private var textFieldFocused: Bool
    @Binding var text: String

    var body: some View {
        TextField("Guess", text: $text)
            .padding()
            .disableAutocorrection(true)
            .keyboardType(.alphabet)
            .focused($textFieldFocused)
            .onAppear {
                textFieldFocused = true
            }
    }
}

struct CityGuessTextField_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessTextField(text: .constant("Hello"))
    }
}
