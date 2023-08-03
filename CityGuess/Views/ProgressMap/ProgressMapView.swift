//
//  ExploreCitiesView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/23/23.
//

import SwiftUI
import MapKit

struct ProgressMapView: View {
    @AppStorage("firstTimeOpeningExploreCities") var isShowingInfoSheet = true
    @EnvironmentObject var guessHistory: CityGuessGameHistoryManager
    @StateObject var viewModel = ProgressMapViewModel()

    var body: some View {
            VStack {
                CityMapView(
                    cityCoordinates: viewModel.coordinates,
                    guessHistory: guessHistory.guessHistory,
                    selectedCityHistory: $viewModel.selectedCity
                )

                Group {
                    if viewModel.coordinates.count > 0 {
                        ProgressGauge(
                            numberCompleted: guessHistory.totalCitiesSeen,
                            totalNumber: guessHistory.totalNumberOfCities,
                            label: guessHistory.totalCitiesSeenLabelText
                        )
                        ProgressGauge(
                            numberCompleted: guessHistory.citiesGuessedCorrectly,
                            totalNumber: guessHistory.totalNumberOfCities,
                            label: guessHistory.totalCitiesGuessedCorrectlyText
                        )
                    }
                }
                .largeTextScrollView()
            }
            .navigationTitle("Progress Map")
            .toolbar {
                OnboardingToolbarButton(isShowingInfoSheet: $isShowingInfoSheet)
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
            .sheet(item: $viewModel.selectedCity) { selectedCity in
                CityDetailView(viewModel: CityDetailViewModel(guessHistory: selectedCity))
                    .dismissable()
            }
    }
}

struct ExploreCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressMapView()
            .environmentObject(CityGuessGameHistoryManager())
    }
}
