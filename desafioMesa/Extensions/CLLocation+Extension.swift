//
//  CLLocation+Extension.swift
//  desafioMesa
//
//  Created by Raissa Morais on 06/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    func bearing(to destination: CLLocation) -> Double {
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0

        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi

        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }

}

extension Double {
    var degreesToRadians: Double { return Double( self * .pi / 180 )  }
    var radiansToDegrees: Double { return Double( self * 180 / .pi )  }
    var toKm: Double { return NSString(format: "%.2f", self/1000).doubleValue }
}

extension CGFloat {
    var toRadians: CGFloat { return self * .pi / 180 }
    var toDegrees: CGFloat { return self * 180 / .pi }
}


