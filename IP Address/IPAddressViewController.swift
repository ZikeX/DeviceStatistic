//
//  TodayViewController.swift
//  IP Address
//
//  Created by Alexsander  on 12/6/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import NotificationCenter

class IPAddressViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - var and let 
    var address = IPAddrees()
    
    // MARK: - IBOutlets
    @IBOutlet weak var celluralImageView: UIImageView!
    @IBOutlet weak var wifiImageView: UIImageView!
    @IBOutlet weak var celluralLabel: UILabel! {
        didSet {
            celluralLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var wifiLabel: UILabel! {
        didSet {
            wifiLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: view.frame.width, height: 50.0)
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
        let celluralImage = UIImage(named: "Cellural.png")
        let wifiImage = UIImage(named: "Wi-Fi.png")
        let getAddress = address.getIFAddresses()
        celluralImageView?.image = celluralImage
        wifiImageView?.image = wifiImage
        
        // 0 cellural  1 wifi

        if getAddress.count == 2 {
            celluralLabel?.text = getAddress[0]
            wifiLabel?.text = getAddress[1]
        } else if getAddress.count == 1 {
            celluralLabel?.text = getAddress[0]
            wifiLabel?.text = "NA"
        } else {
            celluralLabel?.text = "NA"
            wifiLabel?.text = "NA"
        }
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
    
}
