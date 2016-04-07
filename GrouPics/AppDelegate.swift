//
//  AppDelegate.swift
//  GrouPics
//
//  Created by Andrew on 3/26/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase
import GeoFire
import GoogleMaps

var dataBase : Firebase = Firebase()
//var geoRef : GeoFire = GeoFire()
var tabBarController : UITabBarController = UITabBarController()
var tempView : UIViewController = UIViewController()
var storyboard : UIStoryboard = UIStoryboard()
var eventsNavController : UINavigationController = UINavigationController()
var temp : Int = 0
let screenSize: CGRect = UIScreen.mainScreen().bounds
var userID: String = String()
var picked: Int = 0
var eventName : String = String()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        dataBase = Firebase(url:"https://groupics333.firebaseio.com/")
        let tabBarController = self.window!.rootViewController as? UITabBarController
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let eventsNavController = storyboard.instantiateViewControllerWithIdentifier("navView")
        userID = UIDevice.currentDevice().identifierForVendor!.UUIDString
        //setting up google maps
        GMSServices.provideAPIKey("AIzaSyB4bEVGKuvtQLLnCVRIcXKzWfh7aocN_qc")
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

