//
//  StorageMainViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/19/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation

class StorageMainViewController: UIViewController {
    
    // MARK: - var and let
    let fileManager = NSFileManager()
    var boolForStorage = false
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: - IBOutlet
    @IBOutlet weak var usedStorageLabel: UILabel! {
        didSet {
            usedStorageLabel.adjustsFontSizeToFitWidth = true
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                usedStorageLabel.textAlignment = .Center
            }
        }
    }
    
    @IBOutlet weak var freeStorageLabel: UILabel! {
        didSet {
            freeStorageLabel.adjustsFontSizeToFitWidth = true
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                freeStorageLabel.textAlignment = .Center
            }
        }
    }
    
    @IBOutlet weak var totalStorageLabel: UILabel! {
        didSet {
            totalStorageLabel.adjustsFontSizeToFitWidth = true
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                totalStorageLabel.textAlignment = .Center
            }
        }
    }
    
    @IBOutlet weak var storageDrawView: UIView!
    
    // MARK: - override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        self.definesPresentationContext = true
        if boolForStorage == false {
            usedStorageLabel.text = "Used: " + diskSpaceForLabel().usedSize
            freeStorageLabel.text = "Free: " + diskSpaceForLabel().freeSize
            totalStorageLabel.text = "Total: " + diskSpaceForLabel().systemSize
            boolForStorage = true
        }
    }
    
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateStorageData", userInfo: nil, repeats: true)
        // notifications
        notificationCenter.postNotificationName("turnOnStorageInfo", object: nil)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            notificationCenter.postNotificationName("checkStorageOrientation", object: nil)
            notificationCenter.addObserver(self, selector: "storageChangedOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
//        if GlobalTimer.sharedInstance.controllerTimer != nil {
//            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
//            GlobalTimer.sharedInstance.viewTimer?.invalidate()
//        }
        notificationCenter.removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction
    
    // MARK: - functions
    func diskSpaceForLabel() -> (systemSize: String, freeSize: String, usedSize: String) {
        let space = try! fileManager.attributesOfFileSystemForPath(NSHomeDirectory()) as [String : AnyObject]
        let systemS = space["NSFileSystemSize"] as! NSNumber
        let freeS = space["NSFileSystemFreeSize"] as! NSNumber
        
        let byteFormatter = NSByteCountFormatter()
        byteFormatter.allowedUnits = [.UseAll]
        byteFormatter.countStyle = .Binary // file // decimal
        
        let systemSize = byteFormatter.stringFromByteCount(systemS.longLongValue)
        let freeSize = byteFormatter.stringFromByteCount(freeS.longLongValue)
        let usedSize = byteFormatter.stringFromByteCount(systemS.longLongValue - freeS.longLongValue)
        
        return (systemSize, freeSize, usedSize)
    }
    
    func updateStorageData() {
        usedStorageLabel.text = "Used: " + diskSpaceForLabel().usedSize
        freeStorageLabel.text = "Free: " + diskSpaceForLabel().freeSize
        totalStorageLabel.text = "Total: " + diskSpaceForLabel().systemSize
//        print("update storage data")
    }
    
    // MARK: - functions
    
    func storageChangedOrientation() {
        notificationCenter.postNotificationName("checkStorageOrientation", object: nil)
    }
    
}
