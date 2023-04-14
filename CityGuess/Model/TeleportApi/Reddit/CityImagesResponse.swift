//
//  CityImagesResponse.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/11/23.
//

import Foundation

struct CityImagesResponse: Codable {
    let data: Data
    
    struct Data: Codable {
        let children: [Post]
    }
    
    struct Post: Codable {
        let data: CityImage
    }
}
