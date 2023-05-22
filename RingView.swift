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
        // Activity Ring is created by layering a number of different circles
        ZStack {

            // Botttom circle represents the underlying outline visible in an empty ring
            Circle()
                .stroke(outlineColor, lineWidth: lineWidth)

            // Second circle represents what part of the circle is filled in. The circle is trimmed based on the
            // current progress value to only show how much of the progress is complete. The circle is rotated 90 degress to make the progress start at the top of the circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(colors: gradientColors, center: .center, startAngle: .degrees(0), endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // This circle represents the smaller circle at the beginning the progress 

            // This represents the smaller circle at the end of the progress circle's arc
            Circle()
                .frame(width: lineWidth, height: lineWidth)
                .foregroundColor(progress > 0.95 ? gradientColors[1] : gradientColors[1].opacity(0))
                .offset(y: -radius)
                .rotationEffect(.degrees(360 * Double(progress)))
                .shadow(color: progress > 0.96 ? .black.opacity(0.1): .clear, radius: 3, x: 4, y: 0)
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
