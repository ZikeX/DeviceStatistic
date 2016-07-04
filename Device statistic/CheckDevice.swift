//
//  CheckDevice.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/22/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation

public class CheckDevice {
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    public func returnResult(currentView: UIView) -> (radiusArc: CGFloat, lineWidth: CGFloat) {
        var radiusArc: CGFloat!
        var lineWidth: CGFloat!
        let currentDevice = UIDevice.currentDevice().userInterfaceIdiom
            
        switch currentDevice {
        case .Phone:
            radiusArc = orientationForiPhone().radiusArc
            lineWidth = orientationForiPhone().lineWidth
        case .Pad:
            radiusArc = orientationForiPad(currentView).radiusArc
            lineWidth = orientationForiPad(currentView).lineWidth
        default: break
        }
    
        if radiusArc == nil {
            radiusArc = CGFloat(userDefault.floatForKey("radiusARC"))
            lineWidth = CGFloat(userDefault.floatForKey("lineWidth"))
        }
        return (radiusArc, lineWidth)
    }
    
   private func orientationForiPhone() -> (radiusArc: CGFloat, lineWidth: CGFloat) {
        var radiusArc: CGFloat!
        var lineWidth: CGFloat!
        let model = modelName()
        let orientation = UIDevice.currentDevice().orientation
        if model.containsString("Plus") == false {
            switch orientation {
            case .Portrait:
                radiusArc = 100
                lineWidth = 10
                userDefault.setFloat(100, forKey: "radiusARC")
                userDefault.setFloat(10, forKey: "lineWidth")
                userDefault.synchronize()
            case .LandscapeRight, .LandscapeLeft:
                radiusArc = 70 // 70
                lineWidth = 7 // 7
                userDefault.setFloat(70, forKey: "radiusARC")
                userDefault.setFloat(7, forKey: "lineWidth")
                userDefault.synchronize()
            case .FaceUp, .FaceDown, .PortraitUpsideDown:
                radiusArc = CGFloat(userDefault.floatForKey("radiusARC"))
                lineWidth = CGFloat(userDefault.floatForKey("lineWidth"))
            default:
                break
            }
        } else {
            switch orientation {
            case .Portrait:
                radiusArc = 100
                lineWidth = 10
                userDefault.setFloat(100, forKey: "radiusARC")
                userDefault.setFloat(10, forKey: "lineWidth")
                userDefault.synchronize()
            case .LandscapeRight, .LandscapeLeft:
                radiusArc = 90
                lineWidth = 9
                userDefault.setFloat(90, forKey: "radiusARC")
                userDefault.setFloat(9, forKey: "lineWidth")
                userDefault.synchronize()
            case .FaceUp, .FaceDown, .PortraitUpsideDown:
                radiusArc = CGFloat(userDefault.floatForKey("radiusARC"))
                lineWidth = CGFloat(userDefault.floatForKey("lineWidth"))
            default:
                break
            }
        }
        if radiusArc == nil {
            radiusArc = CGFloat(userDefault.floatForKey("radiusARC"))
            lineWidth = CGFloat(userDefault.floatForKey("lineWidth"))
        }
        return (radiusArc, lineWidth)
    }
    
    private func orientationForiPad(currentView: UIView) -> (radiusArc: CGFloat, lineWidth: CGFloat) {
        var radiusArc: CGFloat!
        var lineWidth: CGFloat!
        if currentView.bounds.width == UIScreen.mainScreen().bounds.width {
            radiusArc = 150
            lineWidth = 12
        } else {
            radiusArc = 100
            lineWidth = 10
        }
        return (radiusArc, lineWidth)
    }
    
    public func returnInfoBatteryLabel(currentView: UIView) -> (widthLabel: CGFloat, heightLabel: CGFloat, sizeWidthLabel: CGFloat, sizeHeightLabel: CGFloat, fontLabel: UIFont) {
        var widthLabel: CGFloat!
        var heightLabel: CGFloat!
        var sizeWidthLabel: CGFloat!
        var sizeHeightLabel: CGFloat!
        var fontLabel: UIFont!
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            widthLabel = 60
            heightLabel = 25
            sizeWidthLabel = 30
            sizeHeightLabel = 12.5
            fontLabel = UIFont(name: "HelveticaNeue", size: 23)
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if currentView.bounds.width == UIScreen.mainScreen().bounds.width || modelName() == "iPad Pro" {
                widthLabel = 120
                heightLabel = 35
                sizeWidthLabel = 60
                sizeHeightLabel = 17.5
                fontLabel = UIFont(name: "HelveticaNeue", size: 30)
            } else {
                widthLabel = 60
                heightLabel = 25
                sizeWidthLabel = 30
                sizeHeightLabel = 12.5
                fontLabel = UIFont(name: "HelveticaNeue", size: 23)
            }
        }
        return (widthLabel, heightLabel, sizeWidthLabel, sizeHeightLabel, fontLabel)
    }
    
    func modelName() -> String {
        
        var modelName: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8 where value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro"
            case "AppleTV5,3":                              return "Apple TV"
            case "i386", "x86_64":                          return "Simulator"
            default:                                        return identifier
            }
        }
        return modelName
    }
    
   class func systemInformation() -> (systemVersion: String, modelName: String) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad || UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            let systemVersion = "System Version: iOS \(UIDevice.currentDevice().systemVersion)"
            let model = "Device mode: \(CheckDevice().modelName())"
            return (systemVersion: systemVersion, modelName: model)
        } else {
            return (systemVersion: "", modelName: "")
        }
    }
}

extension String {

}