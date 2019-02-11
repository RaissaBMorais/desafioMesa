//
//  CGFloat+Extension.swift
//  desafioMesa
//
//  Created by Raissa Morais on 06/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation

extension CGFloat {
    var toRadians: CGFloat { return self * .pi / 180 }
    var toDegrees: CGFloat { return self * 180 / .pi }
}
