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
    @Binding var isLoadingNextQuestion: Bool

    var body: some View {
        TextField("Guess", text: $text)
            .keyboardType(.alphabet)
            .focused($textFieldFocused)
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
            .padding()
            .onAppear {
                textFieldFocused = true
            }
            .onChange(of: text) { _ in
                if isLoadingNextQuestion {
                    text = ""
                }
            }
    }
}

struct CityGuessTextField_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessTextField(text: .constant("Hello"), isLoadingNextQuestion: .constant(false))
    }
}
