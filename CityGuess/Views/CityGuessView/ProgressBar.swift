//
//  ProgressBar.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/25/23.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    var color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {

                Rectangle()
                    .fill(color.opacity(0.3))

                Rectangle()
                    .fill(color)
                    .frame(width: min(geo.size.width, geo.size.width * progress))
                    .animation(.linear, value: progress)
            }
            .cornerRadius(45.0)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 20.0, color: .green)
    }
}
