//
//  TodayViewController.swift
//  Battery Monitoring
//
//  Created by Alexsander  on 12/5/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter

class BatteryViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - var and let
    var batteryState = BatteryState()
    let notificationCenter = NSNotificationCenter.defaultCenter()

    // MARK: - IBOutlets
    @IBOutlet weak var batteryStatusLabel: UILabel!
    
    // MARK: - override functions
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: view.frame.size.width, height: 200.0)
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
        let state = batteryState.parseBateryState(batteryState.batteryState().batteryStatus)
        batteryStatusLabel.text = state
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        notificationCenter.postNotificationName("turnOffBatteryWidgetTimer", object: nil)
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
 
    
}
