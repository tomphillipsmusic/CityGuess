//
//  MainMenuButton.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/22/23.
//

import SwiftUI

struct MainMenuButton: View {
    let labelText: String
    let action: () -> Void

    init(_ labelText: String, action: @escaping () -> Void) {
        self.labelText = labelText
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(labelText)
                .font(.title2)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .padding()
    }
}

struct MainMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuButton("Daily Challenge", action: {})
    }
}
