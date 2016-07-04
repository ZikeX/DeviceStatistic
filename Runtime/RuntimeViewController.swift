//
//  TodayViewController.swift
//  Runtime
//
//  Created by Alexsander  on 11/22/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation
import SystemKit

class RuntimeViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - var and let
    var timer: NSTimer!
    let dateFormatter = NSDateComponentsFormatter()
    
    // MARK: - IBOutlets
    @IBOutlet weak var runtimeLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0.0, 50.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
//        self.preferredContentSize = CGSizeMake(0.0, 50.0)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateLabels", userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
  
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
//        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateLabels", userInfo: nil, repeats: true)

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
    
        completionHandler(.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    // MARK: - Functions
    
    func updateLabels() {
        runtimeLabel.text = returnTime() + "     " + returnDay()
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
