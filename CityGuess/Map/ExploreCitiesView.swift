//
//  ExploreCitiesView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/23/23.
//

import SwiftUI
import MapKit

struct ExploreCitiesView: View {
    @EnvironmentObject var guessHistory: CityGuessGameHistoryManager
    @StateObject var viewModel = ExploreCitiesViewModel()
    @Binding var currentScreen: Router.Screen

    var body: some View {
        NavigationStack {
            VStack {
                CityMapView(cityCoordinates: viewModel.coordinates, guessHistory: guessHistory.guessHistory)

                if viewModel.coordinates.count > 0 {
                    Gauge(value: Double(guessHistory.totalCitiesSeen), in: 0.0...Double(viewModel.coordinates.count)) {
                        Text("Total Cities Seen: \(guessHistory.totalCitiesSeen) / \(viewModel.coordinates.count)")
                    }
                    .padding()

                    Gauge(value: Double(guessHistory.citiesGuessedCorrectly), in: 0.0...Double(viewModel.coordinates.count)) {
                        Text("Cities Guessed Correctly: \(guessHistory.citiesGuessedCorrectly) / \(viewModel.coordinates.count)")
                    }
                    .padding()
                }

            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back \(viewModel.coordinates.count)") {
                        currentScreen = .menu
                    }
                }
            }
        }
    }
}

struct ExploreCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCitiesView(currentScreen: .constant(.explore))
            .environmentObject(CityGuessGameHistoryManager())
    }
}
