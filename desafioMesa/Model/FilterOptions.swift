//
//  FilterOptions.swift
//  desafioMesa
//
//  Created by Raissa Morais on 10/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation


class FilterOptions {
    static var optionTypes: [PlaceType] = [.airport, .market, .party, .restaurant, .shopping]
    static var selectedTypes: [PlaceType : Bool] = [.airport : true, .market : true, .party : true, .restaurant : true, .shopping : true]
    
    
    static func selectedFilter() -> [PlaceType] {
        var filter = [PlaceType]()
        for (type , selected) in selectedTypes {
            if selected {
                filter.append(type)
            }
        }
        return filter
    }
    
    
    static func saveFilter(selectedTypes: [PlaceType : Bool]) {
        self.selectedTypes = selectedTypes
    }
    
}
