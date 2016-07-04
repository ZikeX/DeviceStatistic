//
//  NetworkMainViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/18/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import SystemKit

class NetworkMainViewController: UIViewController {
    
    // MARK: - var and let
    var boolForNetworkController = false
    let userDefault = NSUserDefaults(suiteName: "group.com.device.statistic")!
    var system = System()
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
    // MARK: - var and let
    @IBOutlet weak var receivedWiFiLabel: UILabel! {
        didSet {
            receivedWiFiLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var sentWiFiLabel: UILabel! {
        didSet {
            sentWiFiLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var receivedCellularLabel: UILabel! {
        didSet {
            receivedCellularLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var sentCellularLabel: UILabel! {
        didSet {
            sentCellularLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var sinceDateLabel: UILabel! {
        didSet {
            sinceDateLabel.adjustsFontSizeToFitWidth = true
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                sinceDateLabel.textAlignment = .Center
            }
        }
    }
    
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.titleLabel?.textColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
        }
    }

    // MARK: - override function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        self.definesPresentationContext = true
        if boolForNetworkController == false {
            showNetworkData()
            boolForNetworkController = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer.invalidate()
            GlobalTimer.sharedInstance.viewTimer.invalidate()
        }
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showNetworkData", userInfo: nil, repeats: true)
        sinceDate()
        showNetworkData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
//        if GlobalTimer.sharedInstance.controllerTimer != nil {
//            GlobalTimer.sharedInstance.controllerTimer.invalidate()
//        }
//        print("network timer is turned off")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var clearDate: NSDate!
    
    // MARK: - IBAction
    @IBAction func clearData(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Clear network data", message: "Do you want to clear network data?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            self.userDefault.setBool(true, forKey: "boolNetworkDataMain")
            self.userDefault.setDouble(NSProcessInfo().systemUptime, forKey: "systemUptime")
            self.userDefault.setValue(NSDate(), forKey: "clearDate")
            self.userDefault.synchronize()
            self.sinceDate()
            self.clearNetworkData()
        }))
        
        self.view.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - functions
    
    func showNetworkData() {
        let usageData = WiFiMainClass.getDataUsage()
        let byteFormatter = NSByteCountFormatter()
        byteFormatter.allowedUnits = .UseAll
        byteFormatter.countStyle = .Binary
        
        // cellular data
        var cellularReceived: Int!
        var cellularSent: Int!
        var WiFiReceived: Int!
        var WiFiSent: Int!
        
        let clearNetworkDataBool = userDefault.boolForKey("clearNetworkDataBool")
        
        if clearNetworkDataBool == false {
            cellularReceived = Int(usageData.wwan.received)
            cellularSent = Int(usageData.wwan.sent)
            WiFiReceived = Int(usageData.wifi.received)
            WiFiSent = Int(usageData.wifi.sent)
            receivedWiFiLabel.text? = byteFormatter.stringFromByteCount(Int64(WiFiReceived))
            sentWiFiLabel.text? = byteFormatter.stringFromByteCount(Int64(WiFiSent))
            receivedCellularLabel.text? = byteFormatter.stringFromByteCount(Int64(cellularReceived))
            sentCellularLabel.text? = byteFormatter.stringFromByteCount(Int64(cellularSent))
        } else {
            let cellularSavedReceived = userDefault.integerForKey("cellularReceived")
            let cellularSavedSent = userDefault.integerForKey("cellularSent")
            let WiFiSavedReceived = userDefault.integerForKey("WiFiReceived")
            let WiFiSavedSent = userDefault.integerForKey("WiFiSent")
            cellularReceived = Int(usageData.wwan.received) - cellularSavedReceived
            cellularSent = Int(usageData.wwan.sent) - cellularSavedSent
            WiFiReceived = Int(usageData.wifi.received) - WiFiSavedReceived
            WiFiSent = Int(usageData.wifi.sent) - WiFiSavedSent
            
            // set to labels
            receivedWiFiLabel.text = byteFormatter.stringFromByteCount(Int64(WiFiReceived))
            sentWiFiLabel.text = byteFormatter.stringFromByteCount(Int64(WiFiSent))
            receivedCellularLabel.text = byteFormatter.stringFromByteCount(Int64(cellularReceived))
            sentCellularLabel.text = byteFormatter.stringFromByteCount(Int64(cellularSent))
        }
        sinceDate()
    }
    
    
    func sinceDate() {
        let deviceUptime = Double(System.uptime().days) + 10
        var sinceDate: String!
        let boolNetworkDataMain = userDefault.boolForKey("boolNetworkDataMain")
        if boolNetworkDataMain == false {
            let superDate = NSDate(timeInterval: -deviceUptime, sinceDate: NSDate())
            sinceDate = NSDateFormatter.localizedStringFromDate(superDate, dateStyle: .LongStyle, timeStyle: .MediumStyle)
        } else {
            let clearingDate = userDefault.valueForKey("clearDate") as! NSDate
            sinceDate = NSDateFormatter.localizedStringFromDate(clearingDate, dateStyle: .LongStyle, timeStyle: .MediumStyle)
            userDefault.setDouble(NSProcessInfo().systemUptime, forKey: "systemUptime")
        }
        sinceDateLabel.text = "Since \(sinceDate)"
    }
 
    func clearNetworkData() {
        let internetData = WiFiMainClass.getDataUsage()
        let cellularReceived = Int(internetData.wwan.received)
        let cellularSent = Int(internetData.wwan.sent)
        let WiFiReceived = Int(internetData.wifi.received)
        let WiFiSent = Int(internetData.wifi.sent)
        userDefault.setInteger(cellularReceived, forKey: "cellularReceived")
        userDefault.setInteger(cellularSent, forKey: "cellularSent")
        userDefault.setInteger(WiFiReceived, forKey: "WiFiReceived")
        userDefault.setInteger(WiFiSent, forKey: "WiFiSent")
        userDefault.setBool(true, forKey: "clearNetworkDataBool")
        userDefault.synchronize()
//        print(cellularReceived, cellularSent, WiFiReceived, WiFiSent)
    }

}