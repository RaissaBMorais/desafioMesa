//
//  Extension+CLLocation.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension PlaceLocationsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            performSelector(inBackground: #selector(updatePlacesLocation(_:)), with: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastHeading = newHeading
        rotateViews(newHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}


extension PlaceLocationsViewController {
    
    func rotateViews(_ newHeading: CLHeading) {
        
        let rotation = newHeading.trueHeading
        
        let rotationAngle = CGFloat(rotation).toRadians
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.rotationView.transform = CGAffineTransform(rotationAngle:  -rotationAngle)
                
                for view in self.rotationView.subviews {
                    view.transform = CGAffineTransform(rotationAngle:  rotationAngle)
                }

            })
        }
        
    }
    
    @objc func updatePlacesLocation(_ newLocation: CLLocation) {
        
        userLocation = newLocation
        placesService.serviceResponse(location: newLocation, completion: { [weak self] (response, error) in
            if let places = response?.places {
                self?.allPlaceIcons.removeAll()
                
                for place in places {
                    for type in place.types {
                        var placeType: PlaceType!
                        
                        for optionType in FilterOptions.optionTypes {
                            if optionType.isFilteredPlace(type) {
                                placeType = optionType
                                break
                            }
                        }
                        if placeType == nil { placeType = PlaceType(rawValue: "other")! }
                        
                        let placeLocation = place.geometry.location
                        let locationDetails = CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude)
                        let distance = newLocation.distance(from: CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude))
                        let icon = PlaceIcon(placeType: placeType, locationDetails: locationDetails, place: place, distance: distance)
                        self?.allPlaceIcons.append(icon)
                        
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.displayPlaceButtons()
            }
        })
    }
    
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        case .denied:
            // Show error alert or change layout
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show alert
            break
        case .authorizedAlways:
            break
        }
    }
    
}
