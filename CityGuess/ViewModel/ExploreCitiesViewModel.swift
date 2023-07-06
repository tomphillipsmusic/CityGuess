//
//  ExploreCitiesViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import MapKit

@MainActor
class ExploreCitiesViewModel<Service: CoordinatesService, CityFetcher: CityFetching>: ViewModel, ErrorAlertable
    where Service.CityModel == CityFetcher.CityModel {

    @Published var coordinates: [Service.CityCoordinateModel] = []
    @Published var isShowingError = false
    @Published var errorMessage = "Error"

    let citiesClient: CityFetcher
    let coordinatesService: Service

    init(citiesClient: CityFetcher = TeleportApiClient(), coordinatesService: Service = TeleportCoordinatesService()) {
        self.citiesClient = citiesClient
        self.coordinatesService = coordinatesService

        Task {
            await fetchCoordinates()
        }
    }

    func fetchCoordinates() async {
        do {
            let cities = try await fetchCities()
            coordinates = try await coordinatesService.fetchCoordinates(for: cities)
        } catch {
            isShowingError = true
            errorMessage = "There was an error loading city data. Please try again later."
        }
    }

    private func fetchCities() async throws -> [Service.CityModel] {
        if let savedCities: [Service.CityModel] = try? LocalCityService().loadCities() {
            return savedCities
        }

        return try await citiesClient.fetchCities()
    }
}
