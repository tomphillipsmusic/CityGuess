//
//  LockView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/22/23.
//

import SwiftUI

struct LockView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isPopoverShowing = false
    let progress: CGFloat
    let unlockHint: String

    var body: some View {
        ZStack {
            Image("lock")
                .resizable()
            .frame(width: 50, height: 50)
            ActivityRingView(
                progress: progress,
                gradientColors: [.red, .green],
                outlineColor: .gray.opacity(0.5),
                lineWidth: 10
            )
                .frame(width: 100, height: 100)
        }
        .onTapGesture {
            isPopoverShowing = true
        }
        .popover(isPresented: $isPopoverShowing) {
            unlockMessageView
        }
        .if(colorScheme == .dark) { view in
            view.colorInvert()
        }
    }

    var unlockMessageView: some View {
        VStack {
            HStack {
                Spacer()
                Button("Close") {
                    isPopoverShowing = false
                }
                .padding()
            }

            Spacer()
            Text(unlockHint)
            Spacer()
        }
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        LockView(progress: 1.0, unlockHint: "This will unlock tomorrow.")
    }
}
