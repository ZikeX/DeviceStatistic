//
//  MemoryMainViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/18/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import SystemKit

class MemoryMainViewController: UIViewController {
    
    // MARK: - var and let
    var totalMemory = System.memoryUsage()
    let memoryUnit = System()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var boolForMemory = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var activeLabel: UILabel! {
        didSet {
            activeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var inactiveLabel: UILabel! {
        didSet {
            inactiveLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var wiredLabel: UILabel! {
        didSet {
            wiredLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var compressedLabel: UILabel! {
        didSet {
            compressedLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var freeLabel: UILabel! {
        didSet {
            freeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var memoryLabel: UILabel! {
        didSet {
            memoryLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var memoryDrawView: UIView!
    
    // MARK: - override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        self.definesPresentationContext = true
        if boolForMemory == false {
            showMemory()
            boolForMemory = true
        }
        
        let physicalMemory = TotalPhysicalMemory().returnTotalMemory()
        memoryLabel.text = physicalMemory
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showMemory", userInfo: nil, repeats: true)
        // notifications
        
        notificationCenter.postNotificationName("TurnOnMemoryArc", object: nil)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            notificationCenter.postNotificationName("checkMemoryOrientation", object: nil)
            notificationCenter.addObserver(self, selector: "changeMemoryOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
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
    
    // MARK: - IBAction

    // MARK: - memory functions
    
    func showMemory() {
//        print("showMemory")
        let memory = memoryForLabel()
        activeLabel.text = "Active: \(memory.active) MB"
        inactiveLabel.text = "Inactive: \(memory.inactive) MB"
        compressedLabel.text = "Compressed: \(memory.compressed) MB"
        wiredLabel.text = "Wired: \(memory.wired) MB"
        freeLabel.text = "Free: \(memory.free) MB"
    }
    
    func memoryForLabel() -> (active: Double, inactive: Double, wired: Double, compressed: Double, free: Double) {
        let memoryUsage = System.memoryUsage()
        let active = transformMemory(memoryUsage.active)
        let inactive = transformMemory(memoryUsage.inactive)
        let wired  = transformMemory(memoryUsage.wired)
        let compressed = transformMemory(memoryUsage.compressed)
        let free = transformMemory(memoryUsage.free)
        return (active, inactive, wired, compressed, free)
    }
    
    func transformMemory(memory: Double) -> Double {
        let digit = Double(Int(memory * 100000))/100
        return digit
    }
    
    // MARK: - functions
    
    func changeMemoryOrientation() {
//        print("changeMemoryOrientation")
        notificationCenter.postNotificationName("checkMemoryOrientation", object: nil)
    }
    
}
