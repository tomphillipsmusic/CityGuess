//
//  ReviewCitiesView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/31/23.
//

import SwiftUI

struct ReviewCitiesView: View {
    @EnvironmentObject var historyManager: CityGuessGameHistoryManager

    var body: some View {
            TabView {
                ForEach(historyManager.roundHistory.map { $0.value }, id: \.self) { guessHistory in
                    CityDetailView(viewModel: CityDetailViewModel(guessHistory: guessHistory))
                }
            }
            .tabViewStyle(.page)
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.label
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.secondaryLabel
            }
    }
}

struct ReviewCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCitiesView()
            .environmentObject(CityGuessGameHistoryManager())
    }
}
