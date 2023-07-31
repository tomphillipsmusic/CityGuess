//
//  ProgressGauge.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/7/23.
//

import SwiftUI

struct ProgressGauge: View {
    let numberCompleted: Int
    let totalNumber: Int
    let label: String

    var tintColor: Color {
        isComplete ? .yellow : .green
    }
    var isComplete: Bool {
        numberCompleted >= totalNumber
    }

    var body: some View {
        Gauge(
            value: Double(numberCompleted),
            in: 0.0...Double(totalNumber)
        ) {
            Text(label)
                .scaledToFit()
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
        .tint(tintColor)
        .padding()
    }
}

struct ProgressGauge_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProgressGauge(numberCompleted: 50, totalNumber: 100, label: "50 / 100 Completed")
            ProgressGauge(numberCompleted: 100, totalNumber: 100, label: "50 / 100 Completed")
        }
    }
}
