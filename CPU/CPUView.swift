//
//  CPUView.swift
//  Device statistic
//
//  Created by Alexsander  on 11/28/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import DrawKit
import SystemKit

@IBDesignable
class CPUView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - var and let
    let arc = Arc()
    var system = System()
    var timer: NSTimer!
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: - colors
    @IBInspectable var redColor: UIColor = UIColor.redColor()
    @IBInspectable var greenColor: UIColor = UIColor.greenColor()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
//        drawCircle()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawCircle", userInfo: nil, repeats: true)
        notificationCenter.addObserver(self, selector: "turnOffCPUTimer", name: "turnOffTimerCpuWidget", object: nil)
    }
    
    func drawCircle() {
        self.layer.sublayers?.removeAll()
        
        let idle = Double(round(system.usageCPU().idle)/100)
        let usage = 1.0 - idle
        
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: 50, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)
        
        arc.addFigure(path.CGPath, fillColor: .blackColor(), strokeColor: redColor, strokeStart: 0.0, strokeEnd: CGFloat(usage), lineWidth: 8.0, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: greenColor, strokeStart: CGFloat(usage), strokeEnd: 1.0, lineWidth: 8.0, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)

    }

    func turnOffCPUTimer() {
        timer.invalidate()
    }
}
