//
//  CityScoresView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/25/23.
//

import SwiftUI

struct CityScoresView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    let cityScores: [CityScore]

    let gridItems = [
        GridItem(),
        GridItem()
    ]

    var body: some View {
        VStack {
            Text("Stats")
                .font(.title2)
                .padding()

            scoreGauges
                .if(dynamicTypeSize <= .xLarge) { scoreGauges in
                    LazyVGrid(columns: gridItems) {
                        scoreGauges
                    }
                }
        }
    }

    var scoreGauges: some View {
        ForEach(cityScores, id: \.name) { score in
            ProgressGauge(numberCompleted: Int(score.scoreOutOf10), totalNumber: 10, label: score.name)
                .padding()
        }
    }
}

struct CityScoresView_Previews: PreviewProvider {
    static var previews: some View {
        CityScoresView(cityScores: CityScore.testData)
    }
}
