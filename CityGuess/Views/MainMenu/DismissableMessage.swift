//
//  DismissableMessage.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/31/23.
//

import SwiftUI

struct DismissableMessage: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .padding()
            Spacer()
        }
        .dismissable()
    }
}

struct DismissableMessage_Previews: PreviewProvider {
    static var previews: some View {
        Text("First screen")
            .sheet(isPresented: .constant(true)) {
                DismissableMessage(message: "Hello")
            }
    }
}
