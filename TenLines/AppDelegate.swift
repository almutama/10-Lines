//
//  AppDelegate.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register default settings.
        var defaultSettings = Dictionary<String, AnyObject>()
        defaultSettings["server_ip"] = "localhost"
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSettings)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // Setup universal styles for navigation bar.
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.46, green: 0.43, blue: 0.81, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(),
                                                            NSFontAttributeName : UIFont(name: "AmaticSC-Bold", size: 30)!]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // Setup universal styles for tool bar.
        UIToolbar.appearance().barTintColor = UIColor(red: 0.46, green: 0.43, blue: 0.81, alpha: 1.0)
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
        
        // Keyboard manager setup.
        IQKeyboardManager.sharedManager().enable = true
        
        // Login.
        ({ AccountManager.sharedManager.login("bhnascar", password: "foobar") } ~> {})
        
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

