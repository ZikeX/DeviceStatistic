//
//  TotalPhysicalMemory.swift
//  Device statistic
//
//  Created by Alexsander  on 12/4/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import Foundation

public class TotalPhysicalMemory {
    
    public init() { }
    
    public func returnTotalMemory() -> String {
        let mem = NSProcessInfo().physicalMemory
        let digit = Int(mem)/1000000000
        return "Total: \(digit) GB"
    }
    
}