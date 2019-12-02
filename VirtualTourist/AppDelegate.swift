//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/9/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        DB.location.locations { (result) in
            switch result {
            case .success(let locations):
                modelLocation.coordinates = locations
            case .failure(_):
                print("Nothing")
            }
        }  
        return true
    }
}

