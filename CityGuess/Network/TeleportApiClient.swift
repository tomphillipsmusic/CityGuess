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
    }

    private let baseUrl = "https://api.teleport.org/api/"

    func fetchCityImages() async throws -> [CityImage] {
        if cities.isEmpty {
            cities = try await fetchCities()
        }

        var cityImages: [CityImage] = []

        for city in cities {
            let imageResponse: TeleportImageResponse = try await NetworkManager.shared.fetch(from: city.href + Endpoint.images)

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
}
