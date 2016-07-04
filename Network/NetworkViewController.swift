//
//  TodayViewController.swift
//  Network
//
//  Created by Alexsander  on 12/6/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter
import SystemKit

class NetworkViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - var and let
    var timer: NSTimer!
    let userDefault = NSUserDefaults(suiteName: "group.com.device.statistic")!
    
    // MARK: - IBOutlets
    @IBOutlet weak var wifiMark: UIImageView!
    
    @IBOutlet weak var receivedWiFiLabel: UILabel!
    @IBOutlet weak var sentWiFiLabel: UILabel!
    @IBOutlet weak var receivedCellularLbl: UILabel!
    @IBOutlet weak var sentCellularLbl: UILabel!
    @IBOutlet weak var sinceDateLabel: UILabel! {
        didSet {
            sinceDateLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: self.view.bounds.width, height: 247.0)
        sinceDate()
        updateNetwork()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateNetwork", userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    // MARK: - @IBAction
    
    @IBAction func clearData(sender: UIBarButtonItem) {
        userDefault.setBool(true, forKey: "boolNetworkDataMain")
        userDefault.setDouble(NSProcessInfo().systemUptime, forKey: "systemUptime")
        userDefault.setValue(NSDate(), forKey: "clearDate")
        userDefault.synchronize()
        sinceDate()
        clearNetworkData()
    }
    
    // MARK: - functions
    
    func updateNetwork() {
        let usageData = WiFiClass().getDataUsage()
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
            print("clearNetworkDataBool == false ")
            cellularReceived = Int(usageData.wwan.received)
            cellularSent = Int(usageData.wwan.sent)
            WiFiReceived = Int(usageData.wifi.received)
            WiFiSent = Int(usageData.wifi.sent)
            receivedWiFiLabel.text? = byteFormatter.stringFromByteCount(Int64(WiFiReceived))
            sentWiFiLabel.text? = byteFormatter.stringFromByteCount(Int64(WiFiSent))
            receivedCellularLbl.text? = byteFormatter.stringFromByteCount(Int64(cellularReceived))
            sentCellularLbl.text? = byteFormatter.stringFromByteCount(Int64(cellularSent))
        } else {
            print("clearNetworkDataBool == true ")
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
            receivedCellularLbl.text = byteFormatter.stringFromByteCount(Int64(cellularReceived))
            sentCellularLbl.text = byteFormatter.stringFromByteCount(Int64(cellularSent))
        }
    }
    
    func sinceDate()  {
        let deviceUptime = NSTimeInterval(System.uptime().days + 10)
        var sinceDate: String!
        let boolNetworkDataMain = userDefault.boolForKey("boolNetworkDataMain")
        if boolNetworkDataMain == false {
            let superDate = NSDate(timeInterval: -deviceUptime, sinceDate: NSDate())
            sinceDate = NSDateFormatter.localizedStringFromDate(superDate, dateStyle: .LongStyle, timeStyle: .MediumStyle)
        } else {
            let clearingDate = userDefault.valueForKey("clearDate") as! NSDate
            sinceDate = NSDateFormatter.localizedStringFromDate(clearingDate, dateStyle: .LongStyle, timeStyle: .MediumStyle)
//            userDefault.setDouble(NSProcessInfo().systemUptime, forKey: "systemUptime")
            userDefault.synchronize()
        }
        
        sinceDateLabel.text = "Since \(sinceDate)"
    }
    
    func clearNetworkData() {
        let internetData = WiFiClass().getDataUsage()
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
    }
}
