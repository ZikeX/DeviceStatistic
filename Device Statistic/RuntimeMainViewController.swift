//
//  RuntimeMainViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/19/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import SystemKit

class RuntimeMainViewController: UIViewController {
    
    // MARK: - var and let
    let dateFormatter = NSDateComponentsFormatter()
    var boolForRuntime = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var runtimeMainLabel: UILabel! {
        didSet {
            runtimeMainLabel.adjustsFontSizeToFitWidth = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        self.definesPresentationContext = true
        if boolForRuntime == false {
            updateLabels()
            boolForRuntime = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.view.sizeToFit()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if GlobalTimer.sharedInstance.controllerTimer != nil {
            GlobalTimer.sharedInstance.controllerTimer.invalidate()
            GlobalTimer.sharedInstance.viewTimer.invalidate()
        }
        GlobalTimer.sharedInstance.controllerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateLabels", userInfo: nil, repeats: true)
//        print("runtime appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
//        if GlobalTimer.sharedInstance.controllerTimer != nil {
//            GlobalTimer.sharedInstance.controllerTimer.invalidate()
//        }
//        print("runtime disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    

    // MARK: - functions
    
    func updateLabels() {
        runtimeMainLabel.text = returnTime() + "     " + returnDay()
    }
    
    func returnTimeInterval() -> NSTimeInterval {
        let uptime = NSTimeInterval(System.uptime().days + 10)
        return uptime
    }
    
    func returnTime() -> String {
        dateFormatter.unitsStyle = .Short
        dateFormatter.allowedUnits = [.Day, .Hour, .Minute]
        dateFormatter.zeroFormattingBehavior = .Pad
        let time = dateFormatter.stringFromTimeInterval(returnTimeInterval())!
        return time
    }
    
    func returnDay() -> String {
        dateFormatter.unitsStyle = .Short
        dateFormatter.allowedUnits = [.Year, .Month, .Day]
        dateFormatter.zeroFormattingBehavior = .Pad
        let date = NSDate(timeInterval: -returnTimeInterval(), sinceDate: NSDate())
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.dateStyle = .MediumStyle
        let megaDate = formatter.stringFromDate(date)
        return megaDate
    }
}
