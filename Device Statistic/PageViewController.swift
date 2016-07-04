//
//  PageViewController.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/20/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreSpotlight
import MobileCoreServices
import iAd

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - var and let
    var pageViewController: UIPageViewController!
    let controllerIdentifierArray = ["BatteryMonitoringMainViewController", "CPUMainViewController", "IPAddressMainViewController", "MemoryMainViewController", "NetworkMainViewController", "NetworkActivityViewController", "RuntimeMainViewController", "StorageMainViewController"]
    let userDefault = NSUserDefaults.standardUserDefaults()
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var banner: ADBannerView!
    var y: CGFloat!
 
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 47/255, green: 206/255, blue: 255/255, alpha: 1.0)
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
//        pageViewController.view.backgroundColor = .whiteColor()
        self.view.backgroundColor = .whiteColor()
//        let startIndex = appDel.startIndex
  
        pageViewController.view.frame = self.view.frame
        
        let startingController = viewControllerAtIndex(0)! // 0
        
        pageViewController.setViewControllers([startingController], direction: .Forward, animated: false, completion: { done in })
//        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        self.view.gestureRecognizers = pageViewController.gestureRecognizers
        
        // spotlight
        if userDefault.boolForKey("spotlightCheckBoolTwoVersion") == false {
            spotlightSearch()
            userDefault.setBool(true, forKey: "spotlightCheckBoolTwoVersion")
            userDefault.synchronize()
        }
        
        notificationCenter.addObserver(self, selector: "openSearchFromSpotligt", name: "openSpotlight", object: nil)
        if userDefault.boolForKey("ratedAppOnAppStore") == false {
            NSTimer.scheduledTimerWithTimeInterval(12.0, target: self, selector: "checkRating", userInfo: nil, repeats: false)
        }
        
        // banner
//        notificationCenter.addObserver(self, selector: "deviceChangeOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
//        showBanner()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        pageViewController.view.bounds = self.view.bounds
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Page view controller delegate functions
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if (controllerIdentifierArray.count == 0) || (index >= controllerIdentifierArray.count) {
            return nil
        }
        
        let identifier = controllerIdentifierArray[index]
        let controller = storyboard!.instantiateViewControllerWithIdentifier(identifier)
        return controller
    }
    
    func controllerAtIndex(viewController: UIViewController) -> Int {
        return controllerIdentifierArray.indexOf(viewController.restorationIdentifier!)!
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = controllerAtIndex(viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index--
        let identifier = controllerIdentifierArray[index]
        return storyboard!.instantiateViewControllerWithIdentifier(identifier)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = controllerAtIndex(viewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == controllerIdentifierArray.count{
            return nil
        }
        
        let identifier = controllerIdentifierArray[index]
        return storyboard!.instantiateViewControllerWithIdentifier(identifier)
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllerIdentifierArray.count
    }
    

    // MARK: - IBaction
    @IBAction func aboutButton(sender: UIBarButtonItem) {
        let controllerNavi = storyboard!.instantiateViewControllerWithIdentifier("helpNavi")
        self.presentViewController(controllerNavi, animated: true, completion: { done in})
    }
    
    // MARK: - spotlight functions

    func spotlightSearch() {
        if #available(iOS 9.0, *) {
            if CSSearchableIndex.isIndexingAvailable() {
                let deviceListArray = ["CPU" : [["CPU", "central processing unit", "microprocessor"], "Shows Usage and Idle", "1"], "Battery Monitoring" : [["Battery Monitoring", "Battery", "Monitoring"], "Shows Power Source, Charge Percentage", "0"], "Storage" : [["Storage"], "Shows free and used storage", "7"], "Runtime" : [["Runtime"], "Shows when did an iOS device last booted or started", "6"], "Memory" : [["Memory"], "Shows active, inactive, wired, compressed, free and total memory", "3"], "IP Address" : [["IP Address", "IP", "Address", "Wi-Fi", "Cellular"], "Shows IP Address of Wi-Fi or Cellular", "2"], "Network" : [["Network", "Address", "Wi-Fi"], "Shows received or sent data over Wi-Fi or Cellular", "4"], "Network Activity" : [["Network speed", "Speed of network", "Received Data", "Sent Data", "Received", "Sent"], "Network Activity shows you received and sent data, speed of downloading and uploading", "5"]]
            
            for deviceItem in deviceListArray {
                let arrayFromDevice = deviceListArray[deviceItem.0]!
                let keywordsArray = arrayFromDevice[0] as! [String]
                let deviceItemDescription = arrayFromDevice[1] as! String
                let identifierForSpotlight = arrayFromDevice[2] as! String
                let spotlightAttribute = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                spotlightAttribute.title = deviceItem.0
                spotlightAttribute.keywords = keywordsArray
                spotlightAttribute.contentDescription = deviceItemDescription
                
                let spotlightItem = CSSearchableItem(uniqueIdentifier: identifierForSpotlight, domainIdentifier: "item-\(deviceItem.0)", attributeSet: spotlightAttribute)
                
                CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([spotlightItem], completionHandler: { (error) -> Void in
                    if error == nil {
                        
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func openSearchFromSpotligt() {
        let startIndex = appDel.startIndex
        let startingController = viewControllerAtIndex(startIndex)! // 0
        pageViewController.setViewControllers([startingController], direction: .Forward, animated: false, completion: { done in })
    }
    
    //MARK: - function
    func checkRating() {
        if userDefault.boolForKey("selectRatingApp") == false {
            let alertController = UIAlertController(title: nil, message: "Do you want rate on App Store", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Later", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) -> Void in
                let url = NSURL(string: "https://itunes.apple.com/us/app/device-statistic/id1065598550?ls=1&mt=8")!
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                    self.userDefault.setBool(true, forKey: "ratedAppOnAppStore")
                    self.userDefault.synchronize()
                }
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func showBanner() {
        banner = ADBannerView(adType: .Banner)
        y = view.frame.size.height - banner.frame.size.height
        banner.frame = CGRect(origin: CGPoint(x: 0, y: y), size: CGSize())
        banner.delegate = iADClass.sharedInstance
        self.view.addSubview(banner)
        
        let firstConstait = NSLayoutConstraint(item: banner, attribute: .CenterX, relatedBy: .Equal, toItem: super.view, attribute: .CenterX, multiplier: 1, constant: 0)
        firstConstait.priority = 1000
        let secondConstrait = NSLayoutConstraint(item: banner, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: -0)
        secondConstrait.priority = 1000
        firstConstait.active = true
        secondConstrait.active = true
        self.view.addConstraints([firstConstait, secondConstrait])
    }
    
    func deviceChangeOrientation() {
        y = view.frame.size.height - banner.frame.size.height
        banner.frame = CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: 480, height: 50))
    }
}
