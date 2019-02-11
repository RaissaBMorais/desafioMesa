//
//  ProfileUtil.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import Foundation

class ProfileUtil {
    private var defaultsName = "ProfileDataObject"
    
    static let instance: ProfileUtil = {
        let instance = ProfileUtil()
        if let data = UserDefaults.standard.value(forKey: instance.defaultsName) as? Data {
            instance.profile = try? PropertyListDecoder().decode(Profile.self, from: data)
        }
        
        return instance
    }()
    
    var profile: Profile? {
        didSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(profile), forKey: self.defaultsName)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getProfileImage() -> UIImage? {
        if let imageData = profile?.imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func userLogged() -> Bool {
        if self.profile == nil {
            return false
        }
        return true
    }
}
