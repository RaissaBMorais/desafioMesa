//
//  PlaceDetailsView.swift
//  desafioMesa
//
//  Created by Raissa Morais on 06/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PlaceDetailsView: UIView {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    private var placeIcon: PlaceIcon!
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        addSubview(view)
    }
    
    func prepareDetails(icon: PlaceIcon) {
        
        self.placeIcon = icon
        nameLabel.text = icon.place?.name
        addressLabel.text = icon.place?.address
        distanceLabel.text = "Distance: \(icon.distance.toKm)km"
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PlaceDetailsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // BUTTON ACTIONS
    
    @IBAction func openMaps(_ sender: UIButton) {
        
        let coordinate = placeIcon.locationDetails?.coordinate
        
        let regionSpan = MKCoordinateRegion(center: coordinate!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        let placemark = MKPlacemark(coordinate: coordinate!, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = placeIcon.place?.name
        
        mapItem.openInMaps(launchOptions:[
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)
        ] as [String : Any])
        
    }
    
    @IBAction func openWaze(_ sender: UIButton) {
        if (UIApplication.shared.canOpenURL(URL(string:"waze://")!)) {
        
            let coordinate = placeIcon.locationDetails?.coordinate
            let lat = coordinate?.latitude
            let long = coordinate?.longitude
            
            if let lat = lat, let long = long {
                let appScheme = "waze://"
                let params = "?ll=\(lat),\(long)&navigate=yes"
                let url = URL(string: appScheme + params)!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Show error no latitude longitude
            }
            
            
        } else {
            let ac = UIAlertController(title: nil, message: "Could not find Waze app", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }
    
    @IBAction func dismissDetails(_ sender: UIButton) {
        removeFromSuperview()
    }
    
}
