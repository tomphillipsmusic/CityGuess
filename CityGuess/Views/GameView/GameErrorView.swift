//
//  GameErrorView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/5/23.
//

import SwiftUI

struct GameErrorView: View {
    let error: Error
    let confirmationMessage: String
    let confirmationAction: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "xmark.octagon.fill")
                .foregroundColor(.red)
                .font(.largeTitle)
                .padding()

            Text(error.localizedDescription + " Please try again later.")
                .multilineTextAlignment(.center)
                .padding()

            Button(confirmationMessage) {
                confirmationAction()
            }
            .padding()

            Spacer()
        }
    }
}

struct GameErrorView_Previews: PreviewProvider {
    static var previews: some View {
        GameErrorView(error: HttpError.badResponse, confirmationMessage: "Return Home", confirmationAction: {})
    }
}
