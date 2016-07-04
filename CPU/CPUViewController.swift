//
//  TodayViewController.swift
//  CPU
//
//  Created by Alexsander  on 11/22/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation
import SystemKit

class CPUViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - var and let
    var timer: NSTimer!
    var system = System()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: - IBOutlet 
  
    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var idleLabel: UILabel!
    
    // MARK: - override functions
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200.0)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            usageLabel.textAlignment = .Center
            idleLabel.textAlignment = .Center
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
//        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200.0)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showStatisticCPU", userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        notificationCenter.postNotificationName("turnOffTimerCpuWidget", object: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(.NewData) // change 4.12.15
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
