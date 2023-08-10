//
//  TeleportApiClient.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/13/23.
//

import Foundation

actor TeleportApiClient: CityFetching {

    var cities: [TeleportCity] = []

    enum Endpoint {
        static let urbanAreas = "urban_areas"
        static let images = "images"
        static let scores = "scores"
        static let continents = "continents"
    }

    private let baseUrl = "https://api.teleport.org/api/"

    func fetchCityImages() async throws -> [CityImage] {
        if cities.isEmpty {
            cities = try await fetchCities()
        }

        var cityImages: [CityImage] = []

        for city in cities {
            let cityUrlString = city.href + Endpoint.images
            let imageResponse: TeleportImageResponse = try await NetworkManager.shared.fetch(from: cityUrlString)

            if let photo = imageResponse.photos.first {
                cityImages.append(CityImage(title: city.name, url: photo.image.mobile))
            }
        }

        return cityImages
    }

    func fetchCities() async throws -> [TeleportCity] {
        let url = "\(baseUrl)\(Endpoint.urbanAreas)"
        let response: TeleportCitiesResponse = try await NetworkManager.shared.fetch(from: url)
        let decodedCities = response.links.cities
        cities = decodedCities
        return cities
    }
    
    func fetchCities() async throws -> [CGCity] {
        let continents = try await fetchContinents()
        
        var cgCities: [CGCity] = []

        
        for continent in continents {
            
            let cities = try await fetchCities(for: continent)
            
            for city in cities {
                if let city = CGCity(name: city.name, href: city.href, continent: continent) {
                    cgCities.append(city)
                }
            }
        }
        
        return cgCities
    }

    func fetchCoordinateBox(for city: TeleportCity) async throws -> CoordinateBox {
        let response: TeleportCityDetailsResponse = try await NetworkManager.shared.fetch(from: city.href)
        return response.boundingBox.latlon
    }

    func fetchScores(for city: TeleportCity) async throws -> [CityScore] {
        let url = "\(city.href)\(Endpoint.scores)"
        let response: TeleportCityScoresResponse = try await NetworkManager.shared.fetch(from: url)
        return response.categories
    }
}

extension TeleportApiClient: ContinentFetching {
    func fetchContinents() async throws -> [TeleportContinent] {
        let url = "\(baseUrl)\(Endpoint.continents)"
        let response: TeleportContinentsResponse = try await NetworkManager.shared.fetch(from: url)
        return response.links.continents
    }

    func fetchCities(for continent: TeleportContinent) async throws -> [TeleportCity] {
        let url = "\(continent.href)\(Endpoint.urbanAreas)"
        let response: TeleportContinentsResponse.CitiesResponse = try await NetworkManager.shared.fetch(from: url)
        let decodedCities = response.links.cities
        cities = decodedCities
        return cities
    }

    typealias CityModel = TeleportCity

}
