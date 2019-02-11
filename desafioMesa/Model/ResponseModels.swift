//
//  ResponseModels.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation

struct GooglePlacesResponse: Codable {
    
    let places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case places = "results"
    }
}

struct Place: Codable {
    let geometry: Location
    let name : String
    let types: [String]
    let address: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case geometry = "geometry"
        case name = "name"
        case types = "types"
        case address = "vicinity"
        case id = "id"
    }
    
    struct Location: Codable {
        let location: LatLong
        
        enum CodingKeys: String, CodingKey {
            case location = "location"
        }
        
        struct LatLong: Codable {
            let latitude: Double
            let longitude: Double
            
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
            
        }
        
        
    }
}


