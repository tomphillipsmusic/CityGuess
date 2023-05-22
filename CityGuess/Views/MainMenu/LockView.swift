//
//  LockView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/22/23.
//

import SwiftUI

struct LockView: View {
    let progress: CGFloat

    var body: some View {
        Image("lock")
            .resizable()
            .frame(width: 50, height: 50)
        ActivityRingView(progress: progress, gradientColors: [.red, .green], outlineColor: .gray.opacity(0.5), lineWidth: 10)
            .frame(width: 100, height: 100)
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        LockView(progress: 1.0)
    }
}
