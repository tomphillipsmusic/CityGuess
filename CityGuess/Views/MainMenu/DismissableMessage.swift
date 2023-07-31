//
//  DismissableMessage.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/31/23.
//

import SwiftUI

struct DismissableMessage: View {
    let message: String
    var onDismiss: () -> Void = {}

    init(message: String) {
        self.message = message
    }

    init(message: String, onDismiss: @escaping () -> Void) {
        self.message = message
        self.onDismiss = onDismiss
    }

    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text(message)
                   // .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }
            .largeTextScrollView()
            .dismissable()
            .padding()
            .background(
                .background
                    .opacity(0.9)
            )
            .cornerRadius(5)
            .shadow(radius: 0.2)
            .background(Image("city-skyline-background"))
        }
        .onDisappear(perform: onDismiss)
    }
}

struct DismissableMessage_Previews: PreviewProvider {
    static var previews: some View {
        Text("First screen")
            .sheet(isPresented: .constant(true)) {
                DismissableMessage(message: DailyChallengeViewModel().notificationDescription)
            }
    }
}
