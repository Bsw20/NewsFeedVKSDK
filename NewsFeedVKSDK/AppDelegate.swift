//
//  AppDelegate.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 09.10.2020.
//

import UIKit
import VK_ios_sdk
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        print("appDelegate open url worked")
        return true
    }
    

}

