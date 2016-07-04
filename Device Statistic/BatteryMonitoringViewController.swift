//
//  BatteryMonitoringViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/16/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation

class BatteryMonitoringViewController: UIViewController {
    
    // MARK: - var and let
    var notificationCenter = NSNotificationCenter.defaultCenter()
    var boolForBatteryFunc = false
    
    // MARK: IBOutlets
    @IBOutlet weak var batteryLabel: UILabel! {
        didSet {
            batteryLabel.tintColorDidChange()
        }
    }
    
    @IBOutlet weak var batteryDrawView: UIView!
    
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        self.definesPresentationContext = true
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        if boolForBatteryFunc == false {
            batteryStateForLabel()
            boolForBatteryFunc = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "batteryStateForLabel", userInfo: nil, repeats: true)
        
        // notifications
        notificationCenter.postNotificationName("TurnOnMainBatteryTimer", object: nil, userInfo: nil)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            notificationCenter.postNotificationName("changeOrientationBattery", object: nil)
            notificationCenter.addObserver(self, selector: "showOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
//        if GlobalTimer.sharedInstance.controllerTimer != nil {
//            GlobalTimer.sharedInstance.controllerTimer.invalidate()
//            GlobalTimer.sharedInstance.viewTimer.invalidate()
//        }
        notificationCenter.removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction function
  
    
    // MARK: - function
    
    func batteryStateForLabel() {
//        print("batteryStateForLabel")
        let batteryState = BatteryStateMain()
        let batteryStatus = UIDevice.currentDevice().batteryState.rawValue
        switch batteryStatus {
        case 2:
            batteryLabel.textColor = .greenColor()
        default:
            batteryLabel.textColor = .redColor()
        }
        let statusForLabel = batteryState.parseBateryState(batteryStatus)
        batteryLabel.text = statusForLabel
    }
    
    
    func showOrientation() {
        let orientation = UIDevice.currentDevice().orientation
        switch orientation {
        default:
            notificationCenter.postNotificationName("changeOrientationBattery", object: nil)
            notificationCenter.postNotificationName("turnOnMainBatteryTimer", object: nil, userInfo: nil)
        }
    }
}
