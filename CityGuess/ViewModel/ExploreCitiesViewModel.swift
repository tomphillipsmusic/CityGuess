//
//  ExploreCitiesViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/25/23.
//

import MapKit

class ExploreCitiesViewModel<Service: CoordinatesService, CityFetcher: CityFetching>: ObservableObject
    where Service.CityModel == CityFetcher.CityModel {

    @Published var coordinates: [Service.CityCoordinateModel] = []
    @Published var region = MKCoordinateRegion()

    let citiesClient: CityFetcher
    let coordinatesService: Service

    init(citiesClient: CityFetcher = TeleportApiClient(), coordinatesService: Service = TeleportCoordinatesService()) {
        self.citiesClient = citiesClient
        self.coordinatesService = coordinatesService
    }

    @MainActor
    func fetchCoordinates() async {
        do {
            let cities = try await citiesClient.fetchCities()
            coordinates = try await coordinatesService.fetchCoordinates(for: cities)
        } catch {
            print(error)
        }
    }
}
