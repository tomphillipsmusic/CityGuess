//
//  RedditApiClient.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

class RedditClient: CityFetching {
    typealias CityModel = TeleportCity

    private let baseUrl = "https://www.reddit.com/r/cityporn/"
    private let count = 100

    enum Endpoint {
        static let new = "new.json"
    }

    // TODO: Find a cleaner of doing this. Using TeleportAPI Client here to guarantee smaller list of cities.
    func fetchCities() async throws -> [TeleportCity] {
        try await TeleportApiClient().fetchCities()
    }

    func fetchCityImages() async throws -> [CityImage] {
        let url = "\(baseUrl)\(Endpoint.new)?size=\(count)"
        let decodedResponse: CityImagesResponse = try await NetworkManager.shared.fetch(from: url)
        let decodedCities = decodedResponse.data.children.map { $0.data }
        return decodedCities
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
