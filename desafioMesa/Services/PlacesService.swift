//
//  PlacesService.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Alamofire
import CoreLocation


class PlacesService {
    fileprivate let googleApiKey = "AIzaSyBjUqwZAj9uSbgFCuWPawvTZ769ycgJlSA"
    fileprivate let radius = Constants.radius
    fileprivate let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    
    
    func serviceResponse(location: CLLocation, completion: @escaping (_ result: GooglePlacesResponse?, _ error: NSError?) -> Void) {
        
        let latLong = location.coordinate
        let locationString = "location=\(latLong.latitude),\(latLong.longitude)"
        
        let completePath = "\(baseURL)\(locationString)&radius=\(radius)&key=\(googleApiKey)"
        let encoded = (completePath).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        Alamofire.request(encoded ?? "").responseJSON { response in
            switch response.result {
                
            case .success(_):
                if let data = response.data, let placesResponse = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) {
                    completion(placesResponse, nil)
                } else {
                    completion(nil, NSError(domain: "Desafio Mesa", code: 500, userInfo: [NSLocalizedDescriptionKey: "Aconteceu um erro inesperado, tente novamente mais tarde."]))
                }
                
                
            case .failure(let error):
                completion(nil, error as NSError?)
            }
        }
        
    }
    
}

