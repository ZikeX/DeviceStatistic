//
//  MemoryMainView.swift
//  Device Statistic
//
//  Created by Alexsander  on 12/18/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import DrawKit
import SystemKit

class MemoryMainView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: - var and let
    let arc = Arc()
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var boolForMemoryArc = false
    // for ARC
    var memoryArcRadius: CGFloat!
    var lineWidht: CGFloat!
    var path: UIBezierPath!
    
    // MARK: - colors
    @IBInspectable var blackColor: UIColor = .blackColor()
    @IBInspectable var redColor: UIColor = .redColor()
    @IBInspectable var cyanColor: UIColor = .cyanColor()
    @IBInspectable var blueColor: UIColor = .blueColor()
    @IBInspectable var grapeColor: UIColor!
    @IBInspectable var greenColor: UIColor = .greenColor()

    override func drawRect(rect: CGRect) {
        if boolForMemoryArc == false {
            drawMemoryArc()
            turnOnMemoryTimer()
            boolForMemoryArc = true
        }
        notificationCenter.addObserver(self, selector: "turnOnMemoryTimer", name: "TurnOnMemoryArc", object: nil)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            notificationCenter.addObserver(self, selector: "changedMemoryOrientation", name: "checkMemoryOrientation", object: nil)
        }
    }
    
    func drawMemoryArc() {
        self.layer.sublayers?.removeAll()

        let device = CheckDevice().returnResult(self)
        memoryArcRadius = device.radiusArc
        lineWidht = device.lineWidth
        path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: memoryArcRadius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)
         
        let memory = showMemory()
        
        // active cyanColor
        arc.addFigure(path.CGPath, fillColor: blackColor, strokeColor: cyanColor, strokeStart: 0.0, strokeEnd: CGFloat(percentageMemory(memory.active)), lineWidth: lineWidht, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // inactive blue
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: blueColor, strokeStart: CGFloat(percentageMemory(memory.active)), strokeEnd: CGFloat(percentageMemory(memory.active + memory.inactive)), lineWidth: lineWidht, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // wired redColor
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: redColor, strokeStart: CGFloat(percentageMemory(memory.active + memory.inactive)), strokeEnd: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired)), lineWidth: lineWidht, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // compressed yellow
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: grapeColor, strokeStart: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired)), strokeEnd: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired + memory.compressed)), lineWidth: lineWidht, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // free green
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: greenColor, strokeStart: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired + memory.compressed)), strokeEnd: 1.0, lineWidth: lineWidht, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
    }
    
    func turnOnMemoryTimer() {
        if GlobalTimer.sharedInstance.viewTimer != nil {
            GlobalTimer.sharedInstance.viewTimer?.invalidate()
        }
        GlobalTimer.sharedInstance.viewTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawMemoryArc", userInfo: nil, repeats: true)
    }
    
    func percentageMemory(currentMemory: Double) -> Double {
        let memory = showMemory()
        let totalMemory = memory.active + memory.compressed + memory.free + memory.inactive + memory.wired
        let onePercentage = totalMemory / 100
        let returnedMemory = Double(round(currentMemory / onePercentage)/100)
        return returnedMemory
    }
    
    func showMemory() -> (active: Double, inactive: Double, wired: Double, compressed: Double, free: Double) {
        let memoryUsage = System.memoryUsage()
        let active = transformMemory(memoryUsage.active)
        let inactive = transformMemory(memoryUsage.inactive)
        let wired  = transformMemory(memoryUsage.wired)
        let compressed = transformMemory(memoryUsage.compressed)
        let free = transformMemory(memoryUsage.free)
        return (active, inactive, wired, compressed, free)
    }
    
    func transformMemory(memory: Double) -> Double {
        let digit = Double(Int(memory * 1000))/1000
        return digit
    }
    
    // MARK: - functions
    
    func changedMemoryOrientation() {
        GlobalTimer.sharedInstance.orientationTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "drawMemoryArc", userInfo: nil, repeats: false)
        GlobalTimer.sharedInstance.orientationTimer = nil
    }
    
}