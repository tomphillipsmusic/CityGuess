//
//  City.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

struct CityImage: Codable {
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_overridden_by_dest"
        case title
    }

}
