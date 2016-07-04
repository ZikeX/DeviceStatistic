//
//  TodayViewController.swift
//  Memory
//
//  Created by Alexsander  on 12/3/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter
import SystemKit

class MemoryViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - var and let
    var timer: NSTimer!
    var totalMemory = System.memoryUsage()
    let memoryUnit = System()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: - @IBOutlets
    @IBOutlet weak var memoryView: UIView!
    // labels
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var inactiveLabel: UILabel!
    @IBOutlet weak var compressedLabel: UILabel!
    @IBOutlet weak var wiredLabel: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var totalMemoryLabel: UILabel!
    
    // MARK: - override functions
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 258.0)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            activeLabel.textAlignment = .Center
            inactiveLabel.textAlignment = .Center
            compressedLabel.textAlignment = .Center
            wiredLabel.textAlignment = .Center
            freeLabel.textAlignment = .Center
            totalMemoryLabel.textAlignment = .Center
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
//        self.preferredContentSize = CGSize(width: self.view.frame.height, height: 258.0)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showMemory", userInfo: nil, repeats: true)
       
        let physicalMemory = TotalPhysicalMemory().returnTotalMemory()
        totalMemoryLabel.text = physicalMemory
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        notificationCenter.postNotificationName("turnOffMemoryTimerWidget", object: nil)
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
    
    // MARK: - functions
    
    func showMemory() {
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
    
}
