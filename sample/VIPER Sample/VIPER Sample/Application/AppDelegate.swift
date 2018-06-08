//
//  AppDelegate.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/07.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        RootRouter().presentArticleScreen(in: window!)
        ///window?.rootViewController
        return true
    }
}

