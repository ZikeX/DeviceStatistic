//
//  AppDelegate.swift
//  Device statistic
//  Thanks my family
//  Created by Alexsander  on 11/22/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import CoreSpotlight
import Charts
import iAd
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    internal var startIndex = 0
    let notificatioCenter = NSNotificationCenter.defaultCenter()
//    let userDefault = NSUserDefaults.standardUserDefaults()
    let userDefault = NSUserDefaults(suiteName: "group.com.device.statistic")!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let oldState = userDefault.doubleForKey("systemUptime")
        if oldState > NSProcessInfo().systemUptime {
            userDefault.setBool(false, forKey: "boolNetworkDataMain")
            userDefault.setBool(false, forKey: "clearNetworkDataBool")
            userDefault.synchronize()
        }
        
        // for iAd
//        if NSUserDefaults.standardUserDefaults().boolForKey("removePurchaseCompleted") == false {
//            let mainStoryboard = UIStoryboard(name: "MainAD", bundle: NSBundle.mainBundle())
//            let storyVC = mainStoryboard.instantiateInitialViewController()
//            self.window?.rootViewController = storyVC
//            self.window?.makeKeyAndVisible()
//            self.window?.setNeedsDisplay()
//        }
   
        return true
    }
    
    // spotlight
      
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if #available(iOS 9.0, *) {
            if userActivity.activityType == CSSearchableItemActionType {
    //            print("spotlight is doing")
                let identifier = Int(userActivity.userInfo![CSSearchableItemActivityIdentifier] as! String)!
                startIndex = identifier
                notificatioCenter.postNotificationName("openSpotlight", object: nil)
                NetworkActivityViewController.updateTraffic()
            }
        } else {
            // Fallback on earlier versions
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        GlobalTimer.sharedInstance.boolForChangedValue = false
    }

    func applicationWillEnterForeground(application: UIApplication) {
        NetworkActivityViewController.updateTraffic()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        GlobalTimer.sharedInstance.boolForChangedValue = false
    }
}