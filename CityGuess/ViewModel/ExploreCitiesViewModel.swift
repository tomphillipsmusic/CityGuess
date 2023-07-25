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
    @Published var selectedCity: CityGuessHistory?

    let citiesClient: CityFetcher
    let coordinatesService: Service

    let unlockText = "This feature unlocks once you have played at least one game of City Guess"

    init(citiesClient: CityFetcher = TeleportApiClient(), coordinatesService: Service = TeleportCoordinatesService()) {
        self.citiesClient = citiesClient
        self.coordinatesService = coordinatesService

        Task {
            await fetchCoordinates()
        }
    }
    
    init(city: Service.CityModel, citiesClient: CityFetcher = TeleportApiClient(), coordinatesService: Service = TeleportCoordinatesService()) {
        self.citiesClient = citiesClient
        self.coordinatesService = coordinatesService

        Task {
            await try? fetchCoordinates(for: city)
        }
    }

    func fetchCoordinates() async {
        do {
            let cities = try await fetchCities()

            if let defaultCoordinates = try? Bundle.main.decode(
                [CityCoordinate].self,
                from: "InitialCityCoordinates.json"
            ),
                let genericCoordinates = defaultCoordinates as? [Service.CityCoordinateModel] {
                    coordinates = genericCoordinates
                    coordinatesService.save(coordinates)
            }

            coordinates = try await coordinatesService.fetchCoordinates(for: cities)
        } catch {
            isShowingError = true
            errorMessage = "There was an error loading city data. Please try again later."
        }
    }
    
    func fetchCoordinates(for city: Service.CityModel) async throws {
        do {
//            if let defaultCoordinates = try? Bundle.main.decode(
//                [CityCoordinate].self,
//                from: "InitialCityCoordinates.json"
//            ),
//                let genericCoordinates = defaultCoordinates as? [Service.CityCoordinateModel] {
//                coordinatesService.save(coordinates)
//
//            } else {
                let cityCoordinates = try await coordinatesService.fetchCoordinates(for: city)
                coordinates = [cityCoordinates]
            print(coordinates)
//            }
            
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
