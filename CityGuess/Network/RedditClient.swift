//
//  RedditApiClient.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

protocol CityImageFetching {
    func fetchCityImages() async throws -> [CityImage]
}

class RedditClient: CityImageFetching {
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
        let decodedJson = Bundle.main.decode(CityImagesResponse.self, from: Self.filename)
        return decodedJson.data.children.map { $0.data }
    }
}
