//
//  PlaceLocationsViewController.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceLocationsViewController: UIViewController {
    @IBOutlet weak var rotationView: UIView!
    
    var userLocation: CLLocation!
    var userButton: UIButton!
    var lastHeading: CLHeading?
    var placesService = PlacesService()
    let locationManager = CLLocationManager()
    
    var showAllPlaces = FilterOptions.selectedFilter().isEmpty
    
    var placeFilter = FilterOptions.selectedFilter()
    
    var allPlaceIcons = [PlaceIcon]()
    
    var filteredIcons = [PlaceIcon]()
    
    var iconButtons = [PlaceButton]()

    lazy var detailsView: PlaceDetailsView = {
        let width = Int(view.frame.width) - 20
        let height = 180
        let size = CGSize(width: width, height: height)
        let originX = Int(view.center.x) - width/2
        let originY = Int(view.center.y) - height/2
        let origin = CGPoint(x: originX, y: originY)
        let frame = CGRect(origin: origin, size: size)
        let newView = PlaceDetailsView(frame: frame)
        newView.layer.cornerRadius = 10
        newView.layer.masksToBounds = true
        return newView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserButton()
        
        checkLocationServices()
        
    }

    func setupUserButton() {
        
        let imageSize = CGFloat(Constants.userIconSize)
        let xPosition = view.center.x - imageSize/2
        let yPosition = view.center.y - imageSize/2
        let frame = CGRect(x: xPosition, y: yPosition, width: imageSize, height: imageSize)
        userButton = UIButton(frame: frame)
        
        styleUserButton()
    
        let userImage = ProfileUtil.instance.getProfileImage()
        
        userButton.setImage(userImage, for: .normal)
        
        userButton.addTarget(self, action: #selector(logOut(_:)), for: .touchUpInside)
        
        userButton.clipsToBounds = true
        
        rotationView.addSubview(userButton)
    }
    
    func styleUserButton() {
        userButton.layer.cornerRadius = userButton.frame.width/2
        userButton.layer.borderWidth = 3
        userButton.layer.borderColor = UIColor.white.cgColor
        userButton.clipsToBounds = true
        userButton.layer.masksToBounds = true
    }
    
    func displayPlaceButtons() {
        
        filterPlaces()
        
        removePlacesOutOfRadius()
        
        for icon in filteredIcons {
            let iconSubview = rotationView.subviews.filter{ (view) -> Bool in
                if let placeView = view as? PlaceButton {
                    if placeView.icon.place?.id == icon.place?.id {
                        return true
                    }
                }
                return false
            }

            if iconSubview.isEmpty {
                setupIconButton(icon)
            } else {
                if let iconSubview = iconSubview.first as? PlaceButton {
                    iconSubview.icon = icon
                    
                    movePlace(iconSubview)
                    
                }
            }
        }
    }
    
    func removePlacesOutOfRadius() {
        
        let filter = iconButtons.filter { [unowned self] (placeButton) -> Bool in
            if self.filteredIcons.contains(where: { $0.place?.id == placeButton.icon.place?.id }) {
                return true
            }
            placeButton.removeFromSuperview()
            return false
        }
        iconButtons = filter
    }
    
    func movePlace(_ button: PlaceButton) {

        let center = rotationView.center
        
        let newOrigin = button.icon.calculateFrame(userLocation: userLocation, windowCenter: center, iconSize: Constants.placeIconSize)
        
        let sizeFloat = CGFloat(Constants.placeIconSize)
        
        button.center = CGPoint(x: Double(newOrigin.x + sizeFloat/2) , y: Double(newOrigin.y + sizeFloat/2))
    }
    
    func setupIconButton(_ icon: PlaceIcon){
        let iconSize = Constants.placeIconSize
        let windowCenter = view.center
        
        let reference = userLocation
        
        let point = icon.calculateFrame(userLocation: reference, windowCenter: windowCenter, iconSize: iconSize)
        
        let imageSize = CGSize(width: iconSize, height: iconSize)
        let frame = CGRect(origin: point, size: imageSize)
        let iconButton = PlaceButton(icon: icon, frame: frame)
        
        iconButton.setIconImage()
        iconButton.addTarget(self, action: #selector(openPlaceDetails(_:)), for: .touchUpInside)
        
        iconButtons.append(iconButton)
        rotationView.addSubview(iconButton)
        
        if let lastHeading = lastHeading {
            let rotationAngle = CGFloat(lastHeading.trueHeading).toRadians
            iconButton.transform = CGAffineTransform(rotationAngle:  rotationAngle)
        }
    }
    
    
    
    // Button Targets
    @objc func openPlaceDetails(_ button: PlaceButton) {
        if let icon = button.icon {
            detailsView.prepareDetails(icon: icon)
            if detailsView.superview == nil {
                self.view.addSubview(detailsView)
            }
        }
    }

    @objc func logOut(_ button: UIButton) {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
        let authenticationService = AuthenticationService()
        authenticationService.logOut()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func applyFilter(_ sender: UIButton) {
        let FilterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        FilterVC.filterDelegate = self
        present(FilterVC,animated: true)
    }
    
    func filterPlaces() {
        if showAllPlaces {
            filteredIcons = allPlaceIcons
        } else {
            
            filteredIcons = allPlaceIcons.filter { [unowned self] (icon) -> Bool in
                return self.placeFilter.contains(where: {$0 == icon.placeType})
            }
        }
        
    }
    
}

extension PlaceLocationsViewController: filterDelegate {
    func didSelectFilter(filter: [PlaceType]) {
        placeFilter = filter
        showAllPlaces = filter.isEmpty
        displayPlaceButtons()
    }
}
