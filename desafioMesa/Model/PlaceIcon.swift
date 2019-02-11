//
//  PlaceIcon.swift
//  desafioMesa
//
//  Created by Raissa Morais on 04/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum PlaceType: String {
    case airport = "airport"
    case restaurant = "restaurant"
    case party = "night_club"
    case market = "supermarket"
    case shopping = "shopping_mall"
    case other = "other"
    
    func description() -> String {
        return self.rawValue
    }
    
    func isFilteredPlace(_ place: String) -> Bool{
        return place == self.description()
    }
    
}

struct PlaceIcon {
    var placeType: PlaceType
    var locationDetails: CLLocation?
    var place: Place?
    var distance: Double
    
    func calculateFrame(userLocation: CLLocation?, windowCenter center: CGPoint, iconSize: Double) -> CGPoint {
        
        guard let location = self.locationDetails else { return CGPoint(x: -100 , y: -100) }
        guard let referenceLocation = userLocation else { return CGPoint(x: -100 , y: -100) }
        
        let sizeOffset = iconSize/2
        let distance = referenceLocation.distance(from: location)
        let angle = referenceLocation.bearing(to: location).degreesToRadians
        
        
        let sinus = sin(angle)
        let cosinus = cos(angle)
        
        let radius = Constants.radius
        
        let x = distance * sinus
        let y = distance * cosinus
        
        
        let xDoubleCenter = Double(center.x)
        let yDoubleCenter = Double(center.y)
        
        let biggerDimension = (xDoubleCenter > yDoubleCenter) ? xDoubleCenter : yDoubleCenter
        
        let xOffset = (x/radius) * biggerDimension
        let yOffset = (y/radius) * biggerDimension
        
        let xFinal = xDoubleCenter + xOffset - sizeOffset
        let yFinal = yDoubleCenter - yOffset - sizeOffset
        
        return CGPoint(x: xFinal, y: yFinal)
    }
}

