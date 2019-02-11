//
//  PlaceButton.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import UIKit

class PlaceButton: UIButton {
    
    var icon: PlaceIcon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(icon: PlaceIcon, frame: CGRect) {
        super.init(frame: frame)
        self.icon = icon
    }
    
    func setIconImage() {
        
        var imageName = ""
        if icon.placeType == .other {
            imageName = "place_airport"
        } else {
            imageName = "place_\(icon.placeType)"
        }
        setImage(UIImage(named: imageName), for: .normal)
    }

}

