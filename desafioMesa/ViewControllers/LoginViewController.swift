//
//  ViewController.swift
//  desafioMesa
//
//  Created by Raissa Morais on 04/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    @IBOutlet weak var fbButton: UIButton!
    var spinner: SpinnerViewController?
    
    let authenticationService = AuthenticationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ProfileUtil.instance.userLogged() {
            navigateToPlaces(true, nil)
        }
        
    }
    
    func startSpinner() {
        spinner = SpinnerViewController()
        fbButton.isHidden = true
        
        addChild(spinner!)
        spinner!.view.frame = view.frame
        view.addSubview(spinner!.view)
        spinner!.didMove(toParent: self)
        
    }
    
    func stopSpinner() {
        
        guard let spinner = spinner else { return }
        fbButton.isHidden = false
        
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }

    @IBAction func fbButtonTapped(_ sender: UIButton) {
        authenticationService.signIn(completion: userSignedIn(_:_:))
    }
        
    func userSignedIn(_ success: Bool,_ error: String?) {
        
        if success == false {
            // show alert and return
            if let error = error {
                print(error)
            }
            return
        }
        
        startSpinner()
        
        authenticationService.fetchUserData(completion: navigateToPlaces(_:_:))
        
    }
    
    func navigateToPlaces(_ success: Bool,_ error: String?) {
        
        stopSpinner()
        
        if success == false {
            // show alert and return
            if let error = error {
                print(error)
            }
            return
        }
        
        let placeLocationsVC = storyboard?.instantiateViewController(withIdentifier: "PlaceLocationsViewController") as! PlaceLocationsViewController
        present(placeLocationsVC,animated: true)
    }
    
}

