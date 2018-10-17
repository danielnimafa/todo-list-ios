//
//  AppDelegate.swift
//  Todoey
//
//  Created by Daniel Nimafa on 11/09/18.
//  Copyright © 2018 Kipacraft. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        } catch let err {
            print("Error initializing realm: \(err)")
        }
        
        return true
    }

}

