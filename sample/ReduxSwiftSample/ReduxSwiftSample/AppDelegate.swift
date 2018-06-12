//
//  AppDelegate.swift
//  ReduxSwiftSample
//
//  Created by t_nguyen on 2018/06/11.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit
import ReSwift

let store = Store<AppState>(reducer: appReducres, state: AppState())
    //<AppS>(reducer: appReducres, state: AppState(tasks: []))

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

