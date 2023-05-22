//
//  RingView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/22/23.
//

import SwiftUI

struct ActivityRingView: View {
    var progress: CGFloat
    var gradientColors: [Color]
    var outlineColor: Color
    var radius: CGFloat = 150
    var lineWidth: CGFloat

    var body: some View {

        ZStack {

            Circle()
                .stroke(outlineColor, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(colors: gradientColors, center: .center, startAngle: .degrees(0), endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(idealWidth: radius * 2, idealHeight: radius * 2, alignment: .center)
        .animation(.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: progress)
    }
}

struct ActivityRingView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRingView(progress: 0.3, gradientColors: [.red, .green], outlineColor: .gray, lineWidth: 20)
    }
}
