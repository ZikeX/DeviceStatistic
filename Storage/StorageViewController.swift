//
//  TodayViewController.swift
//  Storage
//
//  Created by Alexsander  on 12/4/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter

class StorageViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - var and let
    let fileManager = NSFileManager.defaultManager()
    
    // MARK: - IBOutlets
    @IBOutlet weak var storageView: UIView!
    
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    // MARK: - override functions 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: view.frame.size.width, height: 200.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
        self.preferredContentSize = CGSize(width: view.frame.size.width, height: 209.0)
        let storage = diskSpaceForLabel()
        usedLabel.text = "Used: " + storage.usedSize
        freeLabel.text = "Free: " + storage.freeSize
        totalLabel.text = "Total: " + storage.systemSize
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
    
    func diskSpaceForLabel() -> (systemSize: String, freeSize: String, usedSize: String) {
        let space = try! fileManager.attributesOfFileSystemForPath(NSHomeDirectory()) as [String : AnyObject]
        let systemS = space["NSFileSystemSize"] as! NSNumber
        let freeS = space["NSFileSystemFreeSize"] as! NSNumber
        
        let byteFormatter = NSByteCountFormatter()
        byteFormatter.allowedUnits = [.UseGB, .UseMB, .UseKB]
        byteFormatter.countStyle = .Binary // file // decimal
        
        let systemSize = byteFormatter.stringFromByteCount(systemS.longLongValue)
        let freeSize = byteFormatter.stringFromByteCount(freeS.longLongValue)
        let usedSize = byteFormatter.stringFromByteCount(systemS.longLongValue - freeS.longLongValue)
        
        return (systemSize, freeSize, usedSize)
    }

}
