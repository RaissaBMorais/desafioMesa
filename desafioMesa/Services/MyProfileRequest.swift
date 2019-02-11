//
//  MyProfileRequest.swift
//  desafioMesa
//
//  Created by Raissa Morais on 04/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import FacebookCore

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        let rawResponse: Any?
        
        init(rawResponse: Any?) {
            self.rawResponse = rawResponse
        }
        
        var dictionaryValue: [String: Any]? {
            return rawResponse as? [String: Any]
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, picture.type(large)"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}
