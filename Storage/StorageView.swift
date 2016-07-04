//
//  StorageView.swift
//  Device statistic
//
//  Created by Alexsander  on 12/4/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import DrawKit

@IBDesignable
class StorageView: UIView {
    
    // MARK: - var and let
    var arc = Arc()
    let fileManager = NSFileManager.defaultManager()
    var timer: NSTimer!
    
    // MARK: - colors
    @IBInspectable var blackColor: UIColor = .blackColor()
    @IBInspectable var greenColor: UIColor = .greenColor()
    @IBInspectable var whiteColor: UIColor = .whiteColor()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
//        drawCircle()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawCircle", userInfo: nil, repeats: true)
        
//        let digit = 3 * Double(NSEC_PER_SEC)
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(digit))
//        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
//            self.timer.invalidate()
//        }
    }
    
    func drawCircle() {
        let space = diskSpace()
   
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: 50, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)

        arc.addFigure(path.CGPath, fillColor: blackColor, strokeColor: greenColor, strokeStart: 0.0, strokeEnd: CGFloat(space.usedPercent), lineWidth: 8.0, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: whiteColor, strokeStart: CGFloat(space.usedPercent), strokeEnd: 1.0, lineWidth: 8.0, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        timer.invalidate()
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

}
