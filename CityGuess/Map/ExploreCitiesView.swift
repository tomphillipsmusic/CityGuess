//
//  ExploreCitiesView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/23/23.
//

import SwiftUI
import MapKit

struct ExploreCitiesView: View {
    @AppStorage("firstTimeOpeningExploreCities") var isShowingInfoSheet = true
    @EnvironmentObject var guessHistory: CityGuessGameHistoryManager
    @StateObject var viewModel = ExploreCitiesViewModel()

    var totalCitiesLabelText: String {
        "Total Cities Seen: \(guessHistory.totalCitiesSeen) / \(viewModel.coordinates.count)"
    }

    var citiesGuessedCorrectlyText: String {
        "Cities Guessed Correctly: \(guessHistory.citiesGuessedCorrectly) / \(viewModel.coordinates.count)"
    }

    var body: some View {
            VStack {
                CityMapView(cityCoordinates: viewModel.coordinates, guessHistory: guessHistory.guessHistory)

                Group {
                    if viewModel.coordinates.count > 0 {
                        Gauge(
                            value: Double(guessHistory.totalCitiesSeen),
                            in: 0.0...Double(viewModel.coordinates.count)
                        ) {
                            Text(totalCitiesLabelText)
                        }
                        .padding()

                        Gauge(
                            value: Double(guessHistory.citiesGuessedCorrectly),
                            in: 0.0...Double(viewModel.coordinates.count)
                        ) {
                            Text(citiesGuessedCorrectlyText)
                        }
                        .padding()
                    }
                }
                .largeTextScrollView()
            }
            .navigationTitle("Explore")
            .toolbar {
                Button {
                    isShowingInfoSheet = true
                } label: {
                    Image(systemName: "questionmark.app")
                }

            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.isShowingError) {
                Button("Close", role: .cancel) {}
                Button("Try Again") {
                    Task {
                        await viewModel.fetchCoordinates()
                    }
                }
            }
            .sheet(isPresented: $isShowingInfoSheet) {
                OnboardingView(firstTime: $isShowingInfoSheet, onboarding: .exploreCitiesOnboarding)
            }
    }
}

struct ExploreCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCitiesView()
            .environmentObject(CityGuessGameHistoryManager())
    }
}
