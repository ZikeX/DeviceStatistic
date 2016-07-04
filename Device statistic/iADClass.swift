//
//  iADClass.swift
//  Device Statistic
//
//  Created by Alexsander  on 2/6/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import Foundation
import iAd

public class iADClass: NSObject, ADBannerViewDelegate {
    
    public static let sharedInstance = iADClass()
    
    public func bannerViewDidLoadAd(banner: ADBannerView!) {
        banner.hidden = false
        //        print("bannerViewDidLoadAd my delegate")
    }
    
    public func bannerViewWillLoadAd(banner: ADBannerView!) {
        //        print("bannerViewWillLoadAd my delegate")
    }
    
    public func bannerViewActionDidFinish(banner: ADBannerView!) {
        //        print("bannerDid finish my delegate")
    }
    
    public func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        if error != nil {
            //            print(error?.localizedDescription)
        }
    }
    
    public func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        //        print("bannerViewActionShouldBegin , \(willLeave)")
        return true
    }
    
}