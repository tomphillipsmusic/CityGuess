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
    @EnvironmentObject var historyManager: CityGuessGameHistoryManager
    @StateObject var viewModel = ProgressMapViewModel()

    var body: some View {
            VStack {
                CityMapView(
                    cityCoordinates: viewModel.coordinates,
                    guessHistory: historyManager.guessHistory,
                    selectedCityHistory: $viewModel.selectedCity,
                    selectedContinent: $viewModel.selectedContinent
                )

                ScrollView {
                    if viewModel.coordinates.count > 0 {
                        ProgressGauge(
                            numberCompleted: historyManager.totalCitiesSeen,
                            totalNumber: historyManager.totalNumberOfCities,
                            label: historyManager.totalCitiesSeenLabelText
                        )

                        ForEach(CGContinent.allCases, id: \.self) { continent in
                            let totalNumberOfCities = viewModel.totalNumberOfCities(in: continent)
                            let totalGuessedCorrectly = historyManager.numberOfCitiesGuessedCorrectly(in: continent)

                            if totalNumberOfCities > 0 {
                                ProgressGauge(
                                    numberCompleted: totalGuessedCorrectly,
                                    totalNumber: totalNumberOfCities,
                                    label: "\(continent.progressGaugeLabel)" +
                                    " \(totalGuessedCorrectly) / \(totalNumberOfCities)"
                                )
                                .onTapGesture {
                                    viewModel.selectedContinent = continent
                                }
                            }
                        }
                    } else {
                        ProgressView()
                            .padding()
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
