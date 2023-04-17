//
//  RedditApiClient.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

class RedditClient: CityFetching {
    func fetchCities() async throws -> [GeoNamesCity] {
        #warning("Clean this up so it is not doing a hardcoded filepath")
        try await JsonService().read(from: "bigcities.json")
    }
    
    typealias CityModel = GeoNamesCity
    
    enum Endpoint {
        static let new = "new.json"
    }
    
    private let baseUrl = "https://www.reddit.com/r/cityporn/"
    private let count = 100
    
    func fetchCityImages() async throws -> [CityImage] {
        let url = "\(baseUrl)\(Endpoint.new)?size=\(count)"
        let decodedResponse: CityImagesResponse = try await NetworkManager.shared.fetch(from: url)
        return decodedResponse.data.children.map { $0.data }
    }
}

struct MockRedditClient: CityImageFetching {
    static private let filename = "testcities.json"
    
    func fetchCityImages() async throws -> [CityImage] {
        do {
            let decodedJson = try Bundle.main.decode(CityImagesResponse.self, from: Self.filename)
            return decodedJson.data.children.map { $0.data }
        } catch  {
            print(error)
            throw error
        }
    }
}
