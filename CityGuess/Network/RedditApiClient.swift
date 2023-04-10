//
//  RedditApiClient.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

protocol CityImageFetching {
    func fetchCities() async throws -> [CityImage]
}

class RedditApiClient: CityImageFetching {
    enum Endpoint {
        static let new = "new.json"
    }
    
    struct Response: Codable {
        let data: Data
        
        struct Data: Codable {
            let children: [Post]
        }
        
        struct Post: Codable {
            let data: CityImage
        }
    }
    
    private let baseUrl = "https://www.reddit.com/r/cityporn/"
    private let count = 100
    
    func fetchCities() async throws -> [CityImage] {
        let url = "\(baseUrl)\(Endpoint.new)?size=\(count)"
        let decodedResponse: Response = try await NetworkManager.shared.fetch(from: url)
        return decodedResponse.data.children.map { $0.data }
    }
}   
