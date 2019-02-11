//
//  UIView+Extension.swift
//  desafioMesa
//
//  Created by Raissa Morais on 07/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation

extension UIView {
    
    public func removeSubviewsWithTag(_ tag: Int) {
        for subview in self.subviews {
            if subview.tag == tag {
                subview.removeFromSuperview()
            }
        }
    }
    
}
