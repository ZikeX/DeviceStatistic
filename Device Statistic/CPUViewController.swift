//
//  CPUViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/16/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import SystemKit

class CPUViewController: UIViewController {
    
    // MARK: - var and let
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var drawView: UIView! 
    @IBOutlet weak var usageLabel: UILabel! {
        didSet {
            usageLabel.adjustsFontSizeToFitWidth = true
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                usageLabel.textAlignment = .Center
            }
        }
    }
    
    @IBOutlet weak var idleLabel: UILabel! {
        didSet {
            idleLabel.adjustsFontSizeToFitWidth = true
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                idleLabel.textAlignment = .Center
            }
        }
    }
    
    // MARK: - override functions
    
    var system = System()
    var boolForCPUStatistic = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        self.definesPresentationContext = true
        if boolForCPUStatistic == false {
            showStatisticCPU()
            boolForCPUStatistic = true
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        print("cpu view controller is appear")
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showStatisticCPU", userInfo: nil, repeats: true)
        
        notificationCenter.postNotificationName("TurnOnCPUTimer", object: nil)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            notificationCenter.postNotificationName("orintationCPUDidChange", object: nil)
            notificationCenter.addObserver(self, selector: "changeOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // timer!
//        if GlobalTimer.sharedInstance.controllerTimer != nil {
//            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
//        }
        notificationCenter.removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func showStatisticCPU() {
        let idle = returnCPUInfo(system.usageCPU().idle)
        idleLabel.textColor = .greenColor()
        idleLabel.text = "Idle: \(idle) %"
        usageLabel.textColor = .redColor()
        usageLabel.text = "Usage: \(100.0 - idle) %"
    }
    
    func returnCPUInfo(number: Double) -> Double {
        let digit = Double(round(100 * number) / 100)
        return digit
    }
    
    // MARK: - IBAction
    
    // MARK: - functions
   
    func changeOrientation() {
//        GlobalTimer.sharedInstance.viewTimer.invalidate()
        let orientation = UIDevice.currentDevice().orientation
        switch orientation {
        default:
            notificationCenter.postNotificationName("orintationCPUDidChange", object: nil)
        }
    }
}
