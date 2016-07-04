//
//  BatteryStateMain.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/16/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation

public class BatteryStateMain {
    
    public init() { }
    
    public func batteryState() -> (batteryLevelForArc: Float, percentForLabel: String, batteryStatus: Int){
        let currentDevice = UIDevice.currentDevice()
        currentDevice.batteryMonitoringEnabled = true
        let batteryLevelForArc = currentDevice.batteryLevel
        let percentForLabel = String(Int(batteryLevelForArc * 100))
        let batteryStatus = currentDevice.batteryState.hashValue
        return (batteryLevelForArc, percentForLabel, batteryStatus)
    }
    
    public func parseBateryState(digit: Int) -> String {
        switch digit {
        case 0:
            return "Status battery: Unknown"
        case 1:
            return "Power Source: Battery"
        case 2:
            return "Power Source: Power Adapter"
        case 3:
            return "Power Source: Battery"
        default:
            return "Status battery: Unknown"
        }
    }
}