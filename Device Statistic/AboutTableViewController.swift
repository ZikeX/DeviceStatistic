//
//  HelpTableViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/15/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import StoreKit

class AboutTableViewController: UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - var and let
    let currentDevice = CheckDevice()
    let parametrString = String.indent("\(CheckDevice.systemInformation().systemVersion)\n" + CheckDevice.systemInformation().modelName)
    
    // MARK: - IBOutlets
    @IBOutlet weak var feedbackGesture: UITapGestureRecognizer!
    
    // MARK: - override function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction 
    @IBAction func closeButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Feedback

    @IBAction func feedback(sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            let recipient = "skyalexsandersky@gmail.com"
            mailController.mailComposeDelegate = self
            mailController.setMessageBody(parametrString, isHTML: false)
            mailController.setToRecipients([recipient])
            mailController.setSubject("Device Statistic")
            self.presentViewController(mailController, animated: true, completion: nil)
        }
    }
    
    @IBAction func requestNewFunc(sender: UIGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.delegate = self
            controller.mailComposeDelegate = self
            controller.setSubject("Request a new function")
            controller.setMessageBody(parametrString, isHTML: false)
            let recepient = "skyalexsandersky@gmail.com"
            controller.setToRecipients([recepient])
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultFailed:
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultSaved:
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultSent:
            self.dismissViewControllerAnimated(true, completion: nil)
        default: break
        }
    }
    
    @IBAction func rateAppStore(sender: UITapGestureRecognizer) {
        let stringOfLink = "https://itunes.apple.com/us/app/device-statistic/id1065598550?ls=1&mt=8"
        let url = NSURL(string: stringOfLink)!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath, indexPath.row, indexPath.section)
        switch indexPath {
        case NSIndexPath(forRow: 0, inSection: 3):
            print("remove ad")
            performSegueWithIdentifier("purchasesSegue", sender: self)
        default: break
        }
    }
    
    // MARK: - Table view data source
}

extension String {
    static func indent(mainString: String) -> String {
        return "\n\n\n" + mainString
    }
}
