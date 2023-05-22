//
//  RedditApiClient.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

class RedditClient: CityFetching {
    static let bigCities = "cities.json"
    var cities: [TeleportCity] = []
    let localCityService = LocalCityService()

    func fetchCities() async throws -> [TeleportCity] {
        cities = try localCityService.loadCities()
        print(cities.count.description + " cities in cities.json")
        return cities
    }

    typealias CityModel = TeleportCity

    enum Endpoint {
        static let new = "new.json"
    }

    private let baseUrl = "https://www.reddit.com/r/cityporn/"
    private let count = 100

    func fetchCityImages() async throws -> [CityImage] {
        let url = "\(baseUrl)\(Endpoint.new)?size=\(count)"
        let decodedResponse: CityImagesResponse = try await NetworkManager.shared.fetch(from: url)
        let decodedCities = decodedResponse.data.children.map { $0.data }
        return filterValid(decodedCities)
    }

    private func filterValid(_ cityImages: [CityImage]) -> [CityImage] {
        var result = [CityImage]()

        for image in cityImages {
            for city in cities {
                if image.title.caseInsensitiveContains(city.name) {
                    result.append(image)
                    break
                }
            }
        }

        return result
    }
}

struct MockRedditClient: CityImageFetching {
    static private let filename = "testcities.json"

    func fetchCityImages() async throws -> [CityImage] {
        do {
            let decodedJson = try Bundle.main.decode(CityImagesResponse.self, from: Self.filename)
            return decodedJson.data.children.map { $0.data }
        } catch {
            print(error)
            throw error
        }
    }
}
