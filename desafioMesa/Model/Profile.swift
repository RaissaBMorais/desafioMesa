//
//  Profile.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation

struct Profile: Codable {
    let id: String
    let name: String
    var imageData: Data?
    
    init(fromDictionary dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        let imageURL = ((dictionary["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
        self.imageData = getImageDataFromURL(imageURL)
    }
    
    func getImageDataFromURL(_ imageUrl :String?) -> Data? {
        
        if let imageUrl = imageUrl {
            let url = URL(string: imageUrl)
            let nsdata = NSData(contentsOf: url!)
            return Data(referencing: nsdata!)
        }
        return nil
    }
}
