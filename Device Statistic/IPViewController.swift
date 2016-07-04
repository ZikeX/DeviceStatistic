//
//  IPViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/17/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation

class IPViewController: UIViewController {
    
    // MARK: - var and let 
    var ipAddress = IPAddreesMain()
    var boolForIP = false
    
    // MARK: - IBOutlet 
    @IBOutlet weak var cellularLabel: UILabel! {
        didSet {
            cellularLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var WiFiLabel: UILabel! {
        didSet {
            WiFiLabel.adjustsFontSizeToFitWidth = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            WiFiLabel.textAlignment = .Center
            cellularLabel.textAlignment = .Center
        }
//        print("IP view controller is view did load")
        self.definesPresentationContext = true
        if boolForIP == false {
            let getAddress = ipAddress.getIFAddresses()
        
            if getAddress.count == 2 {
                cellularLabel?.text = getAddress[0]
                WiFiLabel?.text = getAddress[1]
            } else if getAddress.count == 1 {
                cellularLabel?.text = getAddress[0]
                WiFiLabel?.text = "NA"
            } else {
                cellularLabel?.text = "NA"
                WiFiLabel?.text = "NA"
            }
            boolForIP = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showIpInfo", userInfo: nil, repeats: true)

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
//        if GlobalTimer.sharedInstance.controllerTimer != nil {
//            GlobalTimer.sharedInstance.controllerTimer?.invalidate()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - var and let 
   
    // MARK: - function
    
    func showIpInfo() {
        let getAddress = ipAddress.getIFAddresses()
        
        if getAddress.count == 2 {
            cellularLabel?.text = getAddress[0]
            WiFiLabel?.text = getAddress[1]
        } else if getAddress.count == 1 {
            cellularLabel?.text = getAddress[0]
            WiFiLabel?.text = "NA"
        } else {
            cellularLabel?.text = "NA"
            WiFiLabel?.text = "NA"
        }
//        print("show ip info")
    }
}
