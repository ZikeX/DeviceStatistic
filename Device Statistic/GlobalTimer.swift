//
//  GlobalTimer.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/21/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import Foundation

public class GlobalTimer {
    public static let sharedInstance = GlobalTimer()
    private init() { }
    public var controllerTimer: NSTimer!
    public var viewTimer: NSTimer!
    public var orientationTimer: NSTimer!
    public var boolForChangedValue: Bool!
}