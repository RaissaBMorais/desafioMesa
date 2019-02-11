//
//  AuthenticationService.swift
//  desafioMesa
//
//  Created by Raissa Morais on 05/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class AuthenticationService {

    let loginManager = LoginManager()
    
    func signIn(completion: @escaping (_ success: Bool, _ error: String?) -> ()) {
        
        loginManager.logIn(readPermissions: [.publicProfile], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                completion(false, error.localizedDescription)
            case .cancelled:
                completion(false, "User Canceled Login")
            case .success(let grantedPermissions, _,  _):
                if grantedPermissions.contains(where: {$0.name == "public_profile"}) {
                    
                    completion(true, nil)
                    
                } else {
                    completion(false, "No public profile permission found.")
                }
            }
        }
    }
    
    func fetchUserData(completion: @escaping (_ success: Bool, _ error: String?) -> ()) {
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                if let dataResponse = response.dictionaryValue as NSDictionary? {
                    ProfileUtil.instance.profile = Profile(fromDictionary: dataResponse)
                    completion(true, nil)
                }
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
                completion(false, "Error getting user data")
            }
        }
        connection.start()
    }
    
    func logOut() {
        loginManager.logOut()
        let profileInstance = ProfileUtil.instance
        profileInstance.profile = nil
        // Do something later
    }
    
    
}
