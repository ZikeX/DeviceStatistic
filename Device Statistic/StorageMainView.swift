//
//  StorageMainView.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/19/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import DrawKit

class StorageMainView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - colors
    @IBInspectable var blackColor: UIColor = .blackColor()
    @IBInspectable var greenColor: UIColor = .greenColor()
    @IBInspectable var whiteColor: UIColor = .whiteColor()
    
    // MARK: - var and let

    let arc = Arc()
    let fileManager = NSFileManager.defaultManager()
    var deviceCheck = false
    let notificationCenter = NSNotificationCenter.defaultCenter()
    // for arc!
    var radiusStorageArc: CGFloat!
    var lineWidth: CGFloat!
    var path: UIBezierPath!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        drawCircle()
        updateCheckStorageOrientation()
        notificationCenter.addObserver(self, selector: "updateStorageCircle", name: "turnOnStorageInfo", object: nil)
        notificationCenter.addObserver(self, selector: "updateCheckStorageOrientation", name: "checkStorageOrientation", object: nil)
    }
    
    func drawCircle() {
        self.layer.sublayers?.removeAll()
        let device = CheckDevice().returnResult(self)
        radiusStorageArc = device.radiusArc
        lineWidth = device.lineWidth
        path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: radiusStorageArc, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)
        
        let space = diskSpace()
        
        arc.addFigure(path.CGPath, fillColor: blackColor, strokeColor: greenColor, strokeStart: 0.0, strokeEnd: CGFloat(space.usedPercent), lineWidth: lineWidth, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: whiteColor, strokeStart: CGFloat(space.usedPercent), strokeEnd: 1.0, lineWidth: lineWidth, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
    }
    
    func diskSpace() -> (usedPercent: CGFloat, freePercent: CGFloat) {
        let space = try! fileManager.attributesOfFileSystemForPath(NSHomeDirectory()) as [String : AnyObject]
        let systemS = space["NSFileSystemSize"] as! NSNumber
        let freeS = space["NSFileSystemFreeSize"] as! NSNumber
        let usedSpace = systemS.longLongValue - freeS.longLongValue
        
        let onePercent = systemS.longLongValue / 100
        
        let freePercent = CGFloat(freeS.longLongValue / onePercent) / 100
        let usedPercent = CGFloat(usedSpace / onePercent) / 100
        return (usedPercent, freePercent)
    }

    func updateStorageCircle() {
        if GlobalTimer.sharedInstance.viewTimer.valid {
            GlobalTimer.sharedInstance.viewTimer.invalidate()
        }
        GlobalTimer.sharedInstance.viewTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawCircle", userInfo: nil, repeats: true)
    }
    
    // MARK: - functions
    
    func updateCheckStorageOrientation() {
        deviceCheck = false
        GlobalTimer.sharedInstance.orientationTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "drawCircle", userInfo: nil, repeats: false)
        GlobalTimer.sharedInstance.orientationTimer = nil
        updateStorageCircle()
    }
}
