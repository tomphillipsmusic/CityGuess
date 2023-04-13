//
//  TeleportApiClient.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/13/23.
//

import Foundation

actor TeleportApiClient: CityImageFetching, CityFetching {
    
    enum Endpoint {
        static let urbanAreas = "urban_areas"
        static let images = "images"
    }
    
    private let baseUrl = "https://api.teleport.org/api/"
    
    func fetchCityImages() async throws -> [CityImage] {
        let cities = try await fetchCities()
        var cityImages: [CityImage] = []

        do {
            var count = 0
            for city in cities {
                let imageResponse: TeleportImageResponse = try! await NetworkManager.shared.fetch(from: city.href + Endpoint.images)
                if let photo = imageResponse.photos.first {
                    cityImages.append(CityImage(title: city.name, url: photo.image.mobile))
                    count += 1
                    
                    if count > 10 {
                        return cityImages
                    }
                }
            }
            
        } catch {
            print(error)
        }
        
        return cityImages
        //cities.map { CityImage(title: $0.name, url: $0.href + Endpoint.images)}
    }
    
    func fetchCities() async throws -> [TeleportCity] {
        let url = "\(baseUrl)\(Endpoint.urbanAreas)"
        let response: TeleportApiResponse = try await NetworkManager.shared.fetch(from: url)
        return response.links.cities
    }
    
    struct TeleportApiResponse: Codable {
        let count: Int
        let links: Links
        
        enum CodingKeys: String, CodingKey {
            case links = "_links"
            case count
        }
        
        struct Links: Codable {
            let cities: [TeleportCity]
            enum CodingKeys: String, CodingKey {
                case cities = "ua:item"
            }
        }
    }
    
    struct TeleportCity: Codable, City, Identifiable {
        let href: String
        let name: String
        var id: String { href }
    }
    
    struct TeleportImageResponse: Codable {
        let photos: [Photo]
        
//        struct Links: Codable {
//            let photos: [Photo]
//        }
        struct Photo: Codable {
            let image: Image
            
            struct Image: Codable {
                let mobile: String
            }
        }
    }
}
