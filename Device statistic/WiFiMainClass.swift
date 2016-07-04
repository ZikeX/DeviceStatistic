//
//  WiFiMainClass.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/18/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import Foundation

class WiFiMainClass {
        
    class func getDataUsage() -> (wifi : (sent : UInt32, received : UInt32), wwan : (sent : UInt32, received : UInt32)) {
        var interfaceAddresses : UnsafeMutablePointer<ifaddrs> = nil
        var networkData: UnsafeMutablePointer<if_data> = nil
        
        var returnTuple : (wifi : (sent : UInt32, received : UInt32), wwan : (sent : UInt32, received : UInt32)) = ((0, 0), (0, 0))
        
        if getifaddrs(&interfaceAddresses) == 0 {
            for var pointer = interfaceAddresses; pointer != nil; pointer = pointer.memory.ifa_next {
                
                let name : String! = String.fromCString(pointer.memory.ifa_name)
//                print(name);
                // changed it
                _ = Int32(pointer.memory.ifa_flags)
                let addr = pointer.memory.ifa_addr.memory
                //
                if addr.sa_family == UInt8(AF_LINK) {
                    if name.hasPrefix("en") {
                        networkData = unsafeBitCast(pointer.memory.ifa_data, UnsafeMutablePointer<if_data>.self)
                        returnTuple.wifi.sent += networkData.memory.ifi_obytes
                        returnTuple.wifi.received += networkData.memory.ifi_ibytes
                    } else if name.hasPrefix("pdp_ip") {
                        networkData = unsafeBitCast(pointer.memory.ifa_data, UnsafeMutablePointer<if_data>.self)
                        returnTuple.wwan.sent += networkData.memory.ifi_obytes
                        returnTuple.wwan.received += networkData.memory.ifi_ibytes
                    }
                }
            }
            
            freeifaddrs(interfaceAddresses)
        }
        
        return returnTuple
    }
}