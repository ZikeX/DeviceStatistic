//
//  CPUView.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/16/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import DrawKit
import SystemKit

@IBDesignable
class CPUViewMain: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - var and let
    let arc = Arc.sharedInstance
    var system = System()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var boolForCPUView = false
    // MARK: - arc var and let
    var radiusArc: CGFloat!
    var lineWidth: CGFloat!
    var path: UIBezierPath!
    
    // MARK: - colors
    @IBInspectable var redColor: UIColor = UIColor.redColor()
    @IBInspectable var greenColor: UIColor = UIColor.greenColor()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if boolForCPUView == false {
            drawCircle()
            turnOnTimer()
            boolForCPUView = true
        }
        
        notificationCenter.addObserver(self, selector: "turnOnTimer", name: "TurnOnCPUTimer", object: nil)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            notificationCenter.addObserver(self, selector: "checkCPUViewOrintation", name: "orintationCPUDidChange", object: nil)
        }
    }
    
    func drawCircle() {
        layer.sublayers?.removeAll()
        
        let device = CheckDevice().returnResult(self)
        radiusArc = device.radiusArc
        lineWidth = device.lineWidth
        
        path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: radiusArc, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)
        
        let idle = Double(round(system.usageCPU().idle)/100)
        let usage = 1.0 - idle
        
        arc.addFigure(path.CGPath, fillColor: .blackColor(), strokeColor: redColor, strokeStart: 0.0, strokeEnd: CGFloat(usage), lineWidth: lineWidth, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
       arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: greenColor, strokeStart: CGFloat(usage), strokeEnd: 1.0, lineWidth: lineWidth, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
    }
    
    func turnOnTimer() {
        if GlobalTimer.sharedInstance.viewTimer != nil {
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        GlobalTimer.sharedInstance.viewTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawCircle", userInfo: nil, repeats: true)
    }
    
    // MARK: - functions
    
    func checkCPUViewOrintation() {
        GlobalTimer.sharedInstance.orientationTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "drawCircle", userInfo: nil, repeats: false)
        turnOnTimer()
        GlobalTimer.sharedInstance.orientationTimer = nil
    }
   
}