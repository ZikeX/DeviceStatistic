//
//  MemoryArcView.swift
//  Device statistic
//
//  Created by Alexsander  on 12/3/15.
//  Copyright © 2015 Alexsander Khitev. All rights reserved.
//

import UIKit
import DrawKit
import SystemKit

@IBDesignable
class MemoryArcView: UIView {

    // MARK: - var and let
    var arc = Arc()
    var timer: NSTimer!
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: - colors
    @IBInspectable var blackColor: UIColor = .blackColor()
    @IBInspectable var redColor: UIColor = .redColor()
    @IBInspectable var cyanColor: UIColor = .cyanColor()
    @IBInspectable var blueColor: UIColor = .blueColor()
    @IBInspectable var grapeColor: UIColor!
    @IBInspectable var greenColor: UIColor = .greenColor()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        drawMemoryArc()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "drawMemoryArc", userInfo: nil, repeats: true)
        notificationCenter.addObserver(self, selector: "turnOffMemoryTimer", name: "turnOffMemoryTimerWidget", object: nil)
    }
    
    func drawMemoryArc() {
        self.layer.sublayers?.removeAll()
        let memory = showMemory()
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: 50, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI*2 - M_PI_2), clockwise: true)
        
        // active cyanColor
        arc.addFigure(path.CGPath, fillColor: blackColor, strokeColor: cyanColor, strokeStart: 0.0, strokeEnd: CGFloat(percentageMemory(memory.active)), lineWidth: 8, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // inactive blue
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: blueColor, strokeStart: CGFloat(percentageMemory(memory.active)), strokeEnd: CGFloat(percentageMemory(memory.active + memory.inactive)), lineWidth: 8, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // wired redColor
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: redColor, strokeStart: CGFloat(percentageMemory(memory.active + memory.inactive)), strokeEnd: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired)), lineWidth: 8, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // compressed yellow
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: grapeColor, strokeStart: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired)), strokeEnd: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired + memory.compressed)), lineWidth: 8, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
        
        // free green
        arc.addFigure(path.CGPath, fillColor: .clearColor(), strokeColor: greenColor, strokeStart: CGFloat(percentageMemory(memory.active + memory.inactive + memory.wired + memory.compressed)), strokeEnd: 1.0, lineWidth: 8, miterLimit: 0.0, lineDashPhase: 0.0, layer: self.layer)
    
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
    
    func turnOffMemoryTimer() {
        timer.invalidate()
    }

}
